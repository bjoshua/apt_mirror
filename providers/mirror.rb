action :create do

 # update config file
 # run apt-mirror
 # create link to web acessable directory if configured

end

action :update do

  # At this time updates all configured mirrors, not awesome
  # May have to do this with rsync to specify repo to update

end

action :destroy do

 # Remove mirrored repo, files and directory structure
 # Remove web accessable symlink

end
