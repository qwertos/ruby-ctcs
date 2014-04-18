
require 'socket'

module CTCS
	class Client
		attr_reader :family, :port, :hostname, :ip
		
		def initialize csock
			@csock = csock

			@family = @csock.addr[0]
			@port = @csock.addr[1]
			@hostname = @csock.addr[2]
			@ip = @csock.addr[3]
			
			spawn_thread :receive_data
		end


		private

		def receive_data
			data = @csock.readline
			puts data
		end
		
		def spawn_thread sym
			Thread.new do
				loop do
					send sym
				end
			end
		end

	end
end


