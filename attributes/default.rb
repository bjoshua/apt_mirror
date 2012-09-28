# Cookbook Attributes
default[:apt-mirror][:config_location]		= "/etc/apt/mirror.list.d"

# apt-mirror config attributes
default[:apt-mirror][:base_path]		= "/var/spool/apt-mirror"
default[:apt-mirror][:mirror_path]		= "$base_path/mirror"
default[:apt-mirror][:skel_path]		= "$base_bath/skel"
default[:apt-mirror][:var_path]			= "$base_bath/var"
default[:apt-mirror][:cleanscript_path]		= "$var_path"
default[:apt-mirror][:cleanscript_name]		= "clean.sh"
default[:apt-mirror][:cleanscript]		= node[:apt-mirror][:cleanscript_path] + "/" + node[:apt-mirror][:cleanscript_name]
default[:apt-mirror][:defaultarch]	= platform[:arch] #TODO Write OHAI PLUGIN to support this. 
default[:apt-mirror][:postmirror_script_path]	= "$var_path"
default[:apt-mirror][:postmirror_script_name]	= "postmirror.sh"
default[:apt-mirror][:postmirror_script]	= node[:apt-mirror][:postmirror_script_path] + "/" + node[:apt-mirror][:postmirror_script_name]
default[:apt-mirror][:run_postmirror]		= "0"
default[:apt-mirror][:nthreads]			= "20"
default[:apt-mirror][:_tilde]			= "0"


# Notes
# debian systems  - `dpkg --print-architecture`.chomp
# redhat systems - `uname -m`.chomp
