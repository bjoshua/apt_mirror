# Description

This cookbook will provide LWRPs to create, update and destroy apt repo mirrors
using the apt-mirror command. It may also provide a function to set up automatic
 updating of mirrors via cron job. 

# Requirements

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Ch
ef 0.8+ is recommended.

#### Packages
 * apt-mirror 

# Attributes

All attributes are in the `node[:apt-mirror]` namespace 

# Usage


Default attributes set to the apt-mirror defaults

You will need a databag named apt-mirrors with each entry in the databag being t
he repo you want to mirror 
 
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

# Dev Notes

Revisit attributes on resource for web dir

Write OHAI plugin to determine package arch, initial target debian systems must extend for multi-platform.

	* debian systems  - `dpkg --print-architecture`.chomp
	* redhat systems - `uname -m`.chomp

Find a way to move template activation in to create action on mirror resource. This will generate a config file for every mirror and update/destroy specifying the config file. This would allow update action on each configured repo mirror, but does not follow conventions in default apt-mirror behavior but I think it is worth the extra functionality of the cookbook LWRPs. 

