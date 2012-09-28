action :create do

 # write config file for data_bag('name') 
 # run apt-mirror to create mirror on system
 # create link to web acessable directory if configured

end

action :update do

    # call apt-mirror with config file arguement of  default[:apt-mirror][:config_location] + data_bag('name').list 

end

action :destroy do

 # Remove mirrored repo, files and directory structure
 # Remove web accessable symlink

end
