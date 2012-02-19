require 'net/http'
require 'rubygems'
require 'json'

class DownloadJobCreator
  def create_job(attributes)
    uri = URI.parse("#{GrabbitUrl}/download_jobs.json")
    
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data attributes
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end
    
    case response
    when Net::HTTPSuccess
      { "success" => true, "job" => JSON.parse(response.body) }
    else
      { "success" => false, "errors" => JSON.parse(response.body) }
    end
  end
end

