
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



