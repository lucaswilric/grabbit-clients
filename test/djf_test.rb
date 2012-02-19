#!/usr/bin/ruby

require '../config'
require '../lib/download_job_fetcher'

djf = DownloadJobFetcher.new

p djf.get_download_jobs_with_url("http://links.lucasrichter.id.au/post/15663727507")

