require './http_fetcher'
require 'net/http'

require 'rubygems'
require 'json'

class DownloadJobFetcher
  include HttpFetcher
  
  def initialize(grabbit_tag)
    @feed_url = "#{GrabbitUrl}/download_jobs/tagged/#{grabbit_tag}/feed"
    @subscription_url = "#{GrabbitUrl}/subscriptions"
    @download_job_search_url = "#{GrabbitUrl}/download_jobs/search/"
  end

  def get_download_jobs_with_url(url)
    uri = URI.parse(@download_job_search_url)
    
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data "url" => url
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end
    
    case response
    when Net::HTTPSuccess
      JSON.parse response.body
    else
      response.value
    end
  end
  
  def get_download_jobs
    JSON.parse fetch(@feed_url).body
  end
  
  def get_subscription(id)  
    JSON.parse fetch("#{@subscription_url}/#{id}.json").body
  end
end

