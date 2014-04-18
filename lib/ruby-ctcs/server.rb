
require 'socket'

module CTCS
	class Server
		attr_reader :port
		
		def initialize port
			@port = port
			@clients = []

			@ssock = TCPServer.open(@port)
			
			spawn_thread :listen
		end

		def summorize_clients
			torrents = {}
			@clients.each do |x|
				unless torrents.has_key? x.filename then
					torrents[x.filename] = {
						:clients => 0,
						:n_total => 0,
						:n_have  => 0
					}
				end

				torrents[x.filename][:clients] += 1
				torrents[x.filename][:n_total] += x.n_total
				torrents[x.filename][:n_have]  += x.n_have
			end

			return torrents
		end



		private 

		def spawn_thread(sym)
			Thread.new do
				loop do
					send sym
				end
			end	
		end
		
		def listen
			csock = @ssock.accept
			@clients.push( Client.new( csock ) )
		end
	 	
	end
end



