#!/usr/bin/ruby

require './lib/http_fetcher'
require 'net/http'

require 'rubygems'
require 'json'

require './config/grabbit_download_client.config'

require './lib/download_job_runner'
require './lib/download_job_fetcher'
require './lib/download_job_helper'

require './lib/transmission_helper'
  
def save_file(job, subscription, dir)
  destination = DownloadJobHelper.get_destination_for job, subscription
  
  open(destination, "wb") do |file|
    file.write( fetch(job['url']).body )
  end

  file_name = DownloadJobHelper.file_name(job, subscription)

  puts "Downloaded #{job['url']} to #{dir}."
end

jobs = DownloadJobFetcher.new(GrabbitTag).get_download_jobs()

puts "#{ jobs.length } item(s)."

DownloadJobRunner.new().run_jobs(jobs) do |job, subscription|
  dir = DownloadJobHelper.directory(job, subscription)

  save_file job, subscription, dir
end

