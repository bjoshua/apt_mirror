#Create Action

action :create do

  # create link to web acessable directory if configured
  if :docroot.nil || :docroot == ""
    link "#{:docroot}" do
      to "#{node[:apt_mirror][:url]}"
    end
  end 

  # run apt_mirror to create mirror on system

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = node[:apt_mirror][:url].split("/")[2]
 
  # Set up mirror creation, dependant on template to fire it off 
  execute "#{:name}_setup" do
    command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{:name}.list"
    creates "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :nothing
  end
 
  # write config file for name provided via resource call
  # notifies the execute above to create the mirror
  template "#{node[:apt_mirror][:config_location]}/#{:name}.list" do
    source "mirror.list.erb"
    mode 0644
    owner "root"
    group "root"
    variables(
      :config_type => :type, 
      :config_url => :url,
      :config_distribution => :distribution,
      :config_components => [:components]
    )
    notifies :run, resources(:execute => "#{:name}_setup")
  end 

 # if schedule is true make cron entry
 if :schedule 

    cron "#{:name}_cron" do
      minute "#{:schedule[:minute]}"
      hour "#{:schedule[:hour]}" 
      day "#{:schedule[:day]}"
      month "#{:schedule[:month]}"
      weekday "#{:schedule[:weekday]}"
      command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{:name}.list"
      action :create
    end

  end

end


# Update repo action
action :update do

  # call apt_mirror with config file arguement to update repo
  execute "#{:name}_setup" do
    command "/usr/bin/apt_mirror #{node[:apt_mirror][:config_location]}/#{:name}.list"
    creates "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :run
  end

end

# Destroy Repo Action
action :delete do

  # Remove mirrored repo, files and directory structure
  directory "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}" do
    recursive true
    action :delete
  end

  # Remove web accessable symlink
  link ":webloc" do
    action :delete
    only_if ":webloc"
  end

  # remove cron entry if scheduled (needs work)
  if :schedule 
    cron "#{:name}_cron" do
      action :delete
      only_if "#{node[:apt_mirror][:config_location]}/#{:name}.list"
    end
  end

  # Remove apt_mirror config file for specified mirror
  file "#{node[:apt_mirror][:config_location]}/#{:name}.list" do
    action :delete
  end

end
