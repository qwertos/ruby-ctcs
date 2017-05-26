#!/usr/bin/env ruby
#
require 'sinatra'
require_relative 'lib/ruby-ctcs.rb'
require 'pp'
require 'haml'

set :bind, "0.0.0.0"

$server = CTCS::Server.new 2780

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
	
	haml :index
end







