
require_relative 'ruby-ctcs/server.rb'
require_relative 'ruby-ctcs/client.rb'

module CTCS

	STATUS_P2 = /^(?<seeders>\d+):(?<t_seeders>\d+)\/(?<leechers>\d+):(?<t_leechers>\d+)\/(?<connecting>\d+) (?<n_have>\d+)\/(?<n_total>\d+)\/(?<n_avail>\d+) (?<dl_rate>\d+),(?<ul_rate>\d+) (?<dl_total>\d+),(?<ul_total>\d+) (?<dl_limit>\d+),(?<ul_limit>\d+) (?<cache_used>\d+)$/ 

	BW = /^(?<dl_rate>\d+),(?<ul_rate>\d+) (?<dl_limit>\d+),(?<ul_limit>\d+)$/

	CTDETAIL = /^(?<torrent_size>\d+) (?<piece_size>\d+) (?<current_time>\d+) (?<seed_time>\d+)$/


	PROTOCOL_VERSION = "0003"
	
end

