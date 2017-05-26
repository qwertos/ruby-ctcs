#!/usr/bin/env ruby
#
require 'sinatra/base'
require_relative 'lib/ruby-ctcs.rb'
require 'pp'
require 'haml'

=begin
loop do
	print $CLEAR
	$server.refresh_all
	pp $server.summorize_clients
	sleep 1
end
=end
$CLEAR = `clear`

class MyApp < Sinatra::Application
	set :bind, "0.0.0.0"

	def initialize app=nil
		super app

		@server = CTCS::Server.new 2780
	end


	get '/' do 
		@server.refresh_all
		
		haml :index
	end

	run! if app_file == $0
end

