# Description

This cookbook will provide LWRPs to create, update and destroy apt repo mirrors
using the apt-mirror command. It may also provide a function to set up automatic updating of mirrors via cron job. 

# Requirements

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended.

apt-mirror package

# Attributes

# Usage


Default attributes set to the apt-mirror defaults

You will need a databag named aptmirror with each entry in the databag being the repo you want to mirror 
 
example:
deb http://archive.ubuntu.com/ubuntu lucid-updates main restricted universe multiverse
