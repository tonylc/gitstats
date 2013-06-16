# This file is used by Rack-based servers to start the application.

require 'rubygems'
require 'bundler'

Bundler.require

require ::File.expand_path('../config/environment',  __FILE__)
run Gitstats::Application
