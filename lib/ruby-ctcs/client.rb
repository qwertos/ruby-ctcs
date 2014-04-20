
require 'socket'
require 'pp'

module CTCS
	class Client
		attr_reader :family, :port, :hostname, :ip, :version, :filename, 
		            :peerid, :seeders, :total_seeders, :leechers, :total_leechers,
		            :connecting, :n_have, :n_total, :n_avail, :dl_rate, :ul_rate,
		            :dl_total, :ul_total, :dl_limit, :ul_limit, :cache_used
		
		def initialize csock, server
			@csock = csock
			@server = server

			@family = @csock.addr[0]
			@port = @csock.addr[1]
			@hostname = @csock.addr[2]
			@ip = @csock.addr[3]

			@version = ""
			@peerid = ""
			@filename = ""

			@seeders = ""
			@total_seeders = ""
			@leechers = ""
			@total_leechers = ""
			@connecting = ""
			@n_have = ""
			@n_total = ""
			@n_avail = ""
			@dl_rate = ""
			@ul_rate = ""
			@dl_total = ""
			@ul_total = ""
			@dl_limit = ""
			@ul_limit = ""
			@cache_used = ""

			@dl_rate = ""
			@ul_rate = ""
			@dl_limit = ""
			@ul_limit = ""

			@queue = Queue.new
			@ping_respond = false
			
			spawn_thread :receive_data
			spawn_thread :handle_data
		end

		def pause pause=true
			send_ctconfig( "pause", (pause ? "1" : "0"))
		end

		def verbose v=true
			send_ctconfig( "verbose", (v ? "1" : "0"))
		end

		def ping timeout=2
			@ping_respond = false
			send_sendstatus
			sleep timeout
			return @ping_respond
		end

		def refresh
			send_sendstatus
		end


		private

		def unregister
			@server.unregister self
			@csock.close
			@csock = nil
		end

		def receive_data
			data = @csock.readline
			@queue.push data
		end

		def handle_data
			data = @queue.pop
			data.strip!
			words = data.split(" ")
			
			case words[0]
				when 'PROTOCOL'
					receive_protocol words

				when 'AUTH'
					puts "#{words[0]}: Not implemented"

				when 'CTORRENT'
					receive_ctorrent words

				when 'CTSTATUS'
					receive_ctstatus words

				when 'CTBW'
					recieve_ctbw words

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

		def send_protocol version
			begin
				@csock.puts "PROTOCOL #{version}"
			rescue Errno::EPIPE
				unregister
			end
		end

		def send_error message
			puts "not implemented"
		end

		def send_setdlimit dl_limit
			puts "not implemented"
		end

		def send_setulimit ul_limit
			puts "not implemented"
		end

		def send_sendstatus
			begin
				@csock.puts "SENDSTATUS"
			rescue Errno::EPIPE
				unregister
			end
		end

		def send_senddetail
			puts "not implemented"
		end

		def send_sendpeers
			puts "not implemented"
		end

		def send_sendconf
			puts "not implemented"
		end

		def send_ctconfig name, value
			begin
				@csock.puts "CTCONFIG #{name} #{value}"
			rescue Errno::EPIPE
				unregister
			end
		end



		def receive_protocol parsed_command
			@version = parsed_command[1]

			send_protocol PROTOCOL_VERSION
		end

		def receive_auth parsed_command
			puts "not implemented"
		end

		def receive_ctorrent parsed_command
			@peer_id          = parsed_command[1]
			start_timestamp   = parsed_command[2]
			current_timestamp = parsed_command[3]
			@filename         = parsed_command[4]
		end

		def receive_ctstatus parsed_command
			s_string = parsed_command[1..-1].join " "
			matched = STATUS_P2.match( s_string )
			@seeders        = matched[:seeders]
			@total_seeders  = matched[:t_seeders]
			@leechers       = matched[:leechers]
			@total_leechers = matched[:t_leechers]
			@connecting     = matched[:connecting]
			@n_have         = matched[:n_have]
			@n_total        = matched[:n_total]
			@n_avail        = matched[:n_avail]
			@dl_rate        = matched[:dl_rate]
			@ul_rate        = matched[:ul_rate]
			@dl_total       = matched[:dl_total]
			@ul_total       = matched[:ul_total]
			@dl_limit       = matched[:dl_limit]
			@ul_limit       = matched[:ul_limit]
			@cache_used     = matched[:cached]

			@ping_respond = true
		end

		def receive_ctbw parsed_command
			s_string = parsed_command[1..-1].join " "
			matched = BW.match( s_string )
			@dl_rate  = matched[:dl_rate]
			@ul_rate  = matched[:ul_rate]
			@dl_limit = matched[:dl_limit]
			@ul_limit = matched[:ul_limit]
		end

		def receive_ctdetail parsed_command
			puts "not implemented"
		end

		def receive_ctfilestart parsed_command
			puts "not implemented"
		end

		def receive_ctfile parsed_command
			puts "not implemented"
		end

		def receive_ctfilesdone parsed_command
			puts "not implemented"
		end

		def receive_ctpeerstart parsed_command
			puts "not implemented"
		end

		def receive_ctpeer parsed_command
			puts "not implemented"
		end

		def receive_ctpeersdone parsed_command
			puts "not implemented"
		end

		def receive_ctconfigstart parsed_command
			puts "not implemented"
		end

		def receive_ctconfig parsed_command
			puts "not implemented"
		end

		def receive_ctconfigdone parsed_command
			puts "not implemented"
		end


		
		def spawn_thread sym
			Thread.new do
				until @csock == nil do
					begin
						send sym
					rescue
						next
					end
				end
			end
		end

	end
end


