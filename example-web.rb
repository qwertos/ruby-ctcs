#!/usr/bin/env ruby
#
require 'sinatra'
require_relative 'lib/ruby-ctcs.rb'
require 'pp'


$server = CTCS::Server.new 51193

$CLEAR = `clear`


=begin
loop do
	print $CLEAR
	$server.refresh_all
	pp $server.summorize_clients
	sleep 1
end
=end


get '/' do 
	$server.refresh_all
	
	to_return = ""

	to_return += <<EOF
<html>
	<head>
		<title>Ruby CTCS</title>
		<meta http-equiv="refresh" content="5" />
		<link rel="stylesheet" type="text/css" href="css/foundation.css" />
	</head>
	<body>
		<h1>Ruby CTCS</h1>
		<table>
			<tr>
				<th>IP</th>
				<th>Torrent Name</th>
				<th>Peer ID</th>
				<th>Total Leachers</th>
				<th>Total Seeders</th>
				<th>Available</th>
				<th>Have</th>
				<th>Total</th>
				<th>Down Rate</th>
				<th>Up Rate</th>
				<th>Percent</th>
			</tr>

EOF
	
	$server.clients.each do |client|
		to_return += <<EOF
			<tr>
				<td>#{client.hostname}</td>
				<td>#{client.filename}</td>
				<td>#{client.peerid}</td>
				<td>#{client.total_leechers}</td>
				<td>#{client.total_seeders}</td>
				<td>#{client.n_avail}</td>
				<td>#{client.n_have}</td>
				<td>#{client.n_total}</td>
				<td>#{client.dl_rate}</td>
				<td>#{client.ul_rate}</td>
				<td>#{((( client.n_have.to_f / client.n_total.to_f ) * 1000 ).to_i.to_f / 10 )}</td>
			</tr>
				
EOF
	end

	to_return += <<EOF
		</table>
	</body>
</html>
EOF
	
	return to_return
end







