#!/usr/bin/env ruby
require 'logger'
$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')

require 'server'

use Rack::ShowExceptions
run Server.new
