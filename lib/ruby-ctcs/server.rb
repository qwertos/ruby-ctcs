
require 'socket'

module CTCS
	class Server
		attr_reader :port
		attr_reader :clients


		# Create the server and begin listening
		#
		# @param port [Integer] Port number to listen on
		def initialize port
			@port = port
			@clients = []

			@ssock = TCPServer.open(@port)
			
			spawn_thread :listen
		end


		# Get information on the clients
		#
		# @return [Hash] Client info
		def summorize_clients
			torrents = {}
			@clients.each do |x|
				unless torrents.has_key? x.filename then
					torrents[x.filename] = {
						:clients => 0,
						:n_total => 0,
						:n_have  => 0,
						:total_dl_rate => 0,
						:total_ul_rate => 0
					}
				end

				torrents[x.filename][:clients] += 1
				torrents[x.filename][:n_total] += x.n_total.to_i
				torrents[x.filename][:n_have]  += x.n_have.to_i
				torrents[x.filename][:total_dl_rate] += x.dl_rate.to_i
				torrents[x.filename][:total_ul_rate] += x.ul_rate.to_i

			end

			return torrents
		end


		# Refresh the data the server has on the clients.
		def refresh_all
			@clients.each do |x|
				x.refresh
			end
		end


		# Remove client from the client info array.
		#
		# @param client [Client] Client to unregister from the
		#   server.
		def unregister client
			@clients.delete client
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
			@clients.push( Client.new( csock, self ) )
		end
	 	
	end
end



