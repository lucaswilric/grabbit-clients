#!/usr/bin/ruby

require '../lib/download_job_creator'
require '../config'

djc = DownloadJobCreator.new

dir = "music/thingmabob"

  attributes = {
    "download_job[title]" => "jiminy",
    "download_job[tag_names]" => "media",
    "download_job[directory]" => dir,
#    "download_job[url]" => "#{FtpRoot}/#{ dir }/#{ DownloadJobHelper.file_name(job, subscription) }"
    "download_job[url]" => "#{FtpRoot}/#{ dir }/jiminy.txt"
  }

r = DownloadJobCreator.new().create_job(attributes)

p r['success'] ? r['job'] : r['errors']

