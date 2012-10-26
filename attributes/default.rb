# Cookbook Attributes
default[:apt_mirror][:databag_name]		= "apt_mirror"
default[:apt_mirror][:config_location]		= "/etc/apt/mirror.list.d"

# apt_mirror config attributes
default[:apt_mirror][:base_path]		= "/var/spool/apt_mirror"
default[:apt_mirror][:mirror_path]		= "$base_path/mirror"
default[:apt_mirror][:skel_path]		= "$base_bath/skel"
default[:apt_mirror][:var_path]			= "$base_bath/var"
default[:apt_mirror][:cleanscript_path]		= "$var_path"
default[:apt_mirror][:cleanscript_name]		= "clean.sh"
default[:apt_mirror][:cleanscript]		= node[:apt_mirror][:cleanscript_path] + "/" + node[:apt_mirror][:cleanscript_name]
default[:apt_mirror][:defaultarch]	= platform[:arch] #TODO Write OHAI PLUGIN to support this. 
default[:apt_mirror][:postmirror_script_path]	= "$var_path"
default[:apt_mirror][:postmirror_script_name]	= "postmirror.sh"
default[:apt_mirror][:postmirror_script]	= node[:apt_mirror][:postmirror_script_path] + "/" + node[:apt_mirror][:postmirror_script_name]
default[:apt_mirror][:run_postmirror]		= "0"
default[:apt_mirror][:nthreads]			= "20"
default[:apt_mirror][:_tilde]			= "0"


# Notes
# debian systems  - `dpkg --print-architecture`.chomp
# redhat systems - `uname -m`.chomp
