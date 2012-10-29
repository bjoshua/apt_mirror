# Description

This cookbook will provide LWRPs to create, update and destroy apt repo mirrors
using the apt_mirror command. It may also provide a function to set up automatic
 updating of mirrors via cron job. 

# Requirements

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Ch
ef 0.8+ is recommended.

#### Packages
 * apt-mirror 

# Attributes

All attributes are in the `node[:apt_mirror]` namespace 

# Usage

WARNING: Mirroring Large Repos will of course make your chef run as long as it takes to download the repo. 

Default attributes set to the apt_mirror defaults from the config file included with the package. 

How to call in a recipe

```
apt_mirror_mirror "opscode_lucid_10" do
  action :create
  type "deb"
  url "http://apt.opscode.com/"
  distribution "lucid-0.10"
  components [ "main" ]
  clean "http://apt.opscode.com/"
  cron true
  schedule ({ :minute => "0", :hour => "0", :day => "1", :month => "1", :weekday
 => "*"}) # once a year on the first of the year at midnight
  docroot "/var/www/repos/chef"
end
```

###action create will

* create the apt-mirror config file based on the included template, using attributes defined.
* run apt-mirror as the user apt-mirror to install the repo based on the config file named. 
* symlink to a specified location to make the repo web accessable 
* schedule updates to the repo via the apt-mirror users crontab. 

###action update will

* execue apt-mirror as teh apt-mirror user with the specified mirror config file

###action delete will

* remove the repo and all sub-dirs
* remove the symlink into your web accessable directory. 
* remove the cron entry if a schedule was set
* remove the apt-mirror config file for the mirror specified 


## Suggested Use Pattern
databag named apt_mirrors with each entry in the databag being the repo you want to mirror 
 
example data bag entry:

```
{
  "id": "mirror_name",
  "type": "<binary | source>",
  "url": "http://your.repo.com/",
  "distribution": "<distribution>",
  "components": [
	"component1",
	"component2"
   ]
}
```

iterate over each entry with a apt_mirror_mirror create action.

# Dev Notes

## Things Left to do
skip sections if not specified. 

  * schedule is not a hash check to see if it is set to false
  * do not symlink if it is not specified

Useful Logging

Other error handling


Write OHAI plugin to determine package arch, initial target debian systems must extend for multi-platform.

	* debian systems  - `dpkg --print-architecture`.chomp
	* redhat systems - `uname -m`.chomp


