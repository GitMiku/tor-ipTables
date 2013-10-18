#!/bin/sh
#install.sh
#Make sure to update toriptables.sh with your user information
#Before running this script
#Run me as root


mv toriptables.sh /etc/init.d/
update-rc.d -f tor remove
update-rc.d tor defaults 80 20
update-rc.d toriptables.sh defaults 90 10
