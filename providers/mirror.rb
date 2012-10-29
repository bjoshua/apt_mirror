 
#Create Action

action :create do

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = new_resource.url.split("/")[2]

  # run apt_mirror to create mirror on system

  # Set up mirror creation, dependant on template to fire it off 
  execute "#{new_resource.name}_setup" do
    command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{new_resource.name}.list"
    creates "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}" 
    action :nothing
  end
 
  # write config file for name provided via resource call
  # notifies the execute above to create the mirror
  template "#{node[:apt_mirror][:config_location]}/#{new_resource.name}.list" do
    source "mirror.list.erb"
    mode "0644"
    owner "root"
    group "root"
    variables(
      :config_type => new_resource.type, 
      :config_url => new_resource.url,
      :config_distribution => new_resource.distribution,
      :config_components => [new_resource.components]
    )
    notifies :run, resources(:execute => "#{new_resource.name}_setup")
  end 

  # create link to web acessable directory if configured
  if new_resource.docroot
    link "#{new_resource.docroot}/#{new_resource.name}" do
      to "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}"
    end
  end 


 # if schedule is true make cron entry
 if new_resource.schedule 

    cron "#{new_resource.name}_cron" do
      minute "#{new_resource.schedule[:minute]}"
      hour "#{new_resource.schedule[:hour]}" 
      day "#{new_resource.schedule[:day]}"
      month "#{new_resource.schedule[:month]}"
      weekday "#{new_resource.schedule[:weekday]}"
      command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{new_resource.name}.list"
      action :create
    end

  end

end


# Update repo action
action :update do

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = new_resource.url.split("/")[2]

  # call apt_mirror with config file arguement to update repo
  execute "#{new_resource.name}_setup" do
    command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{new_resource.name}.list"
    action :run
  end

end

# Destroy Repo Action
action :delete do

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = new_resource.url.split("/")[2]

  # Remove web accessable symlink
  link "#{new_resource.docroot}/#{new_resource.name}" do
    action :delete
    only_if do ::File.symlink?("#{new_resource.docroot}/#{new_resource.name}") end
  end

  # Remove mirrored repo, files and directory structure
  directory "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir}" do
    recursive true
    action :delete
  end

  directory "#{node[:apt_mirror][:skel_path]}/#{createdMirrorDir}" do
    recursive true
    action :delete
  end

  # remove cron entry if scheduled (needs work)
  # remove cron entry if scheduled (needs work)
  if :schedule 
    cron "#{new_resource.name}_cron" do
      action :delete
      only_if do ::File.exists?("#{node[:apt_mirror][:config_location]}/#{new_resource.name}.list") end
    end
  end

  # Remove apt_mirror config file for specified mirror
  file "#{node[:apt_mirror][:config_location]}/#{new_resource.name}.list" do
    action :delete
  end

end
