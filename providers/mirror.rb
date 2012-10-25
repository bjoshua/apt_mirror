#Create Action

action :create do

  # create link to web acessable directory if configured
  if :docroot.nil || :docroot == ""
    link "#{:docroot}" do
      to "#{node[:apt-mirror][:url]}"
    end
  end 

  # run apt-mirror to create mirror on system

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = node[:apt-mirror][:url].split("/")[2]
 
  # Set up mirror creation, dependant on template to fire it off 
  execute "#{:name}-setup" do
    command "/usr/bin/apt-mirror #{node[:apt-mirror][:config_location]}/#{:name}.list"
    creates "#{node[:apt-mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :nothing
  end
 
  # write config file for name provided via resource call
  # notifies the execute above to create the mirror
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
 # .split("/")[2]

  cron "#{:name}-cron" do
    minute "#{:schedule[:minute]}"
    hour "#{:schedule[:hour]}" 
    day "#{:schedule[:day]}"
    month "#{:schedule[:month]}"
    weekday "#{:schedule[:weekday]}"
    command "/usr/bin-apt-mirror #{node[:apt-mirror][:config_location]}/#{:name}.list"
    action :create
  end

end

# Update repo action
action :update do

  # call apt-mirror with config file arguement to update repo
  execute "#{:name}-setup" do
    command "/usr/bin/apt-mirror #{node[:apt-mirror][:config_location]}/#{:name}.list"
    creates "#{node[:apt-mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :run
  end

end

# Destroy Repo Action
action :delete do

  # Remove mirrored repo, files and directory structure
  directory "#{node[:apt-mirror][:mirror_path]}/#{createdMirrorDir}" do
    recursive true
    action :delete
  end

  # Remove web accessable symlink
  link ":webloc" do
    action :delete
    only_if ":webloc"
  end

  # remove cron entry if scheduled (needs work)
  cron "#{:name}-cron" do
    action :delete
    only_if "#{node[:apt-mirror][:config_location]}/#{:name}.list"
  end

  # Remove apt-mirror config file for specified mirror
  file "#{node[:apt-mirror][:config_location]}/#{:name}.list" do
    action :delete
  end

end
