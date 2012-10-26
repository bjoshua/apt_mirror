#Create Action

action :create do

  # create link to web acessable directory if configured
  if new_resource.docroot
    link "#{new_resource.docroot}" do
      to "#{new_resource.url}"
    end
  end 

  # run apt_mirror to create mirror on system

  # separate the url to get the dir name of the created mirror
  createdMirrorDir = new_resource.url.split("/")[2]
  puts "CHECK CLASS"
  puts createdMirrorDir.class 
  puts createdMirrorDir
 
  # Set up mirror creation, dependant on template to fire it off 
  execute "#{new_resource.name}_setup" do
    command "/usr/bin/apt-mirror #{node[:apt_mirror][:config_location]}/#{new_resource.name}.list"
    creates "#{node[:apt_mirror][:mirror_path]}/#{createdMirrorDir.split("/")[2]}" 
    action :nothing
  end
 
  # write config file for name provided via resource call
  # notifies the execute above to create the mirror
  template "#{node[:apt_mirror][:config_location]}/#{new_resource.name}.list" do
    source "mirror.list.erb"
    mode 0644
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

  # call apt_mirror with config file arguement to update repo
  execute "#{new_resource.name}_setup" do
    command "/usr/bin/apt_mirror #{node[:apt_mirror][:config_location]}/#{new_resource.name}.list"
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
  link ":docroot" do
    action :delete
    only_if ":docroot"
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
