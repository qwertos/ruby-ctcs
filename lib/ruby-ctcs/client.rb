
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

			@queue = Queue.new
			
			spawn_thread :receive_data
			spawn_thread :handle_data
		end


		private

		def receive_data
			data = @csock.readline
			@queue << data
		end

		def handle_data
			data = @queue.pop
			data.strip!
			words = data.split [" "]
			
			case words[0]
				when 'PROTOCOL'
					puts "#{words[0]}: Not implemented"

				when 'AUTH'
					puts "#{words[0]}: Not implemented"

				when 'CTORRENT'
					puts "#{words[0]}: Not implemented"

				when 'CTSTATUS'
					puts "#{words[0]}: Not implemented"

				when 'CTBW'
					puts "#{words[0]}: Not implemented"

				when 'CTDETAIL'
					puts "#{words[0]}: Not implemented"

				when 'CTFILESTART'
					puts "#{words[0]}: Not implemented"

				when 'CTFILE'
					puts "#{words[0]}: Not implemented"

				when 'CTFILESDONE'
					puts "#{words[0]}: Not implemented"

				when 'CTPEERSTART'
					puts "#{words[0]}: Not implemented"

				when 'CTPEER'
					puts "#{words[0]}: Not implemented"

				when 'CTPEERSDONE'
					puts "#{words[0]}: Not implemented"

				when 'CTCONFIGSTART'
					puts "#{words[0]}: Not implemented"

				when 'CTCONFIG'
					puts "#{words[0]}: Not implemented"

				when 'CTCONFIGDONE'
					puts "#{words[0]}: Not implemented"


				else
					puts "#{words[0]}: Not implemented"

			end
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


