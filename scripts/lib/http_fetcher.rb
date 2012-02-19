class NotFoundError < StandardError
end

module HttpFetcher
  def fetch(uri_str, cache = true, limit = 10)
    raise ArgumentError, 'Too many redirections!' if limit == 0
    
    uri = URI.parse(uri_str)
    
    puts "Fetching " + uri.to_s
       
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      path_and_query = uri.path == nil ? '' : uri.path
      path_and_query += uri.query == nil ? '' : '?' + uri.query
      http.get path_and_query, { 'Cache-Control' => 'no-cache' }
    end
    
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then 
      puts "Redirected to: " + response['location']
      
      new_uri = absolutize response['location'], uri
      
      fetch(new_uri, cache, limit - 1)
    when Net::HTTPNotFound    then
      raise NotFoundError
    else
      raise "#{response.code} #{response.message} when requesting #{uri_str}"
    end
  end
  
  def absolutize(relative, context)
    uri = URI.parse(relative)
    
    uri.scheme ||= context.scheme
    uri.host ||= context.host
    uri.port ||= context.port
    uri.path ||= context.path
    uri.query ||= context.query
    
    uri.to_s
  end
end
