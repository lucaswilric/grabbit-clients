require './http_fetcher'

class DownloadJobRunner
  include HttpFetcher

  def update(job, status)
    uri = URI.parse("#{GrabbitUrl}/download_jobs/#{job['id']}.json")
    
    request = Net::HTTP::Put.new(uri.path)
    request.set_form_data :id => job['id'], "download_job[status]" => Status[status]
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end
    
    case response
    when Net::HTTPSuccess
      job['status'] = Status[status]
    
      response
    else
      response.value
    end
  end
  
  def run_jobs(jobs = [], do_update = true)
    jobs.each do |job|
      update job, :in_progress if do_update
      
      subscription = DownloadJobFetcher.new('pug').get_subscription(job['subscription_id']) if job['subscription_id']
      
      begin
      
        yield job, subscription if block_given?

        update job, :finished if do_update
      rescue
        update job, :failed if do_update
        #puts $!
        raise
      end
    end
  end
end
