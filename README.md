# Description

This cookbook will provide LWRPs to create, update and destroy apt repo mirrors
using the apt-mirror command. It may also provide a function to set up automatic updating of mirrors via cron job. 

# Requirements

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended.

apt-mirror package

# Attributes

# Usage


Default attributes set to the apt-mirror defaults

You will need a databag named apt-mirrors with each entry in the databag being the repo you want to mirror 
 
example:
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


# Dev Notes

Revisit attributes on resource for web dir
Write OHAI plugin to determine package arch, initial target debian systems must extend for multi-platform.

Could create a mirror.list.d directory and create a config file for every
miror and update/destroy specifying the config file. This would overcome update being a global update to all configured repos, but does not follow conventions in default apt-mirror behavior but I think it is worth the extra functionality of the cookbook LWRPs. 
