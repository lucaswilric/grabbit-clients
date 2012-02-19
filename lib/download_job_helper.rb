class DownloadJobHelper
  def self.file_name(job, subscription = nil)
    file = job['url'].sub(/.*\/([^\/]+)\/?\Z/, '\1')
    
    if subscription and subscription['extension']
      unless file.downcase.match /\.#{ subscription['extension'].downcase }\Z/
          file << ".#{ subscription['extension'] }"
      end
    end
    
    file
  end
  
  def self.directory(job, subscription = nil)
    if job['directory'] and job['directory'] != ""
      job['directory']
    elsif subscription and subscription['destination'] and subscription['destination'] != ""
      subscription['destination']
    else
      ""
    end
  end

  def self.make_directory(dir_path)
    return if File.directory? dir_path

    puts "Making directory '#{dir_path}'." 
      
    parent_path = dir_path[0..dir_path.rindex('/')].chomp('/')
    make_directory(parent_path)
      
    umask = File.umask(0000)

    Dir.mkdir(dir_path, 0777)

    File.umask(umask)
  end

  def self.get_destination_for(job, subscription)
    dir_path = get_path_for job, subscription

    file_name = DownloadJobHelper.file_name(job, subscription)
    
    destination = "#{ dir_path }/#{ file_name }"
  end

  def self.get_path_for(job, subscription)
    # Copy the contents of DestinationRoot to a new instance, so we don't mutate the original.
    dir_path = String.new(DestinationRoot)
     
    dir_path << "/" + DownloadJobHelper.directory(job, subscription)
              
    dir_path = File.expand_path(dir_path.chomp('/'))

    unless dir_path.match /\A#{ DestinationRoot.chomp('/') }/
      raise "Download #{ job.id } tried to save outside '#{ DestinationRoot }', in #{ dir_path }"
    end
      
    make_directory dir_path

    dir_path
  end
end
