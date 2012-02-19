#!/usr/bin/ruby

require '../lib/transmission_helper'

require 'rubygems'
require 'json'

th = TransmissionHelper.new "url" => "http://localhost:9091/transmission/rpc", "username" => "transmission", "password" => "n8Xic6RS"

p th.add_torrent '/media/20D0FF1ED0FEF93C/Downloads/audiobooks', 'librivox - the return of sherlock holmes - sir arthur conan doyle.torrent'

