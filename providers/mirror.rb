action :create do

 # create link to web acessable directory if configured

 # run apt-mirror to create mirror on system

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = node[:apt-mirror][:url].split("/")[3]
  
  execute "#{:name}-setup" do
    command "/usr/bin/apt-mirror -c #{node[:apt-mirror][:config_location]}/#{:name}.list"
    creates "#{node[:apt-mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :nothing
  end
 
 # write config file for name provided via resource call
  
  template "#{node[:apt-mirror][:config_location]}/#{:name}.list" do
    source "mirror.list.erb"
    mode 0644
    owner "root"
    group "root"
    variables(
    :type => data_bag_item("#{mirror}", 'type')
    :url => data_bag_item("#{mirror}", 'url')
    :distribution => data_bag_item("#{mirror}", 'distribution')
    :components => data_bag_item("#{mirror}", 'components')
    notifies :run, resources(:execute => "#{:name}-setup")
    )
  end 

 # schedule update via cron if specified
 # if databag schdule or schedule called in resource create cron

  cron "noop" do
    hour "5"
    minute "0"
    command "/bin/true"
    action :create
  end

end

action :update do

    # call apt-mirror with config file arguement of default[:apt-mirror][:config_location] + data_bag('name').list 

end

action :destroy do

 # Remove mirrored repo, files and directory structure
 # Remove web accessable symlink


  # remove cron entry if scheduled
  
    cron "noop" do
      hour "5"
      minute "0"
      command "/bin/true"
      action :delete
    end

  # Remove apt-mirror config file for specified mirror

end
