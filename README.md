# expressvpn_monitor
Simple set of scripts to start and monitor ExpressVPN (openvpn) on LibreElec

Note, the main vpn.sh script must be in a cron that runs frequently.  I run it once a minute to check for stalled OpenVPN processes.

The express.ovpn OpenVPN config file references a custom "up" script for OpenVPN that adds a local route for the 192.168.0.0/16 private network so that this system can still access the local network, and be accessed by systems on the local network.  Adding the same route multiple times will not cause issues as the ip utility ignores "duplicate" default routes that match identically.

In addition, a basic user/password is stored in a file.  This is "insecure", but to make it more secure I simply add this file every time I reboot to /dev/shm/ and this userpass file symlinks to it.

```
auth-user-pass /storage/.express.userpass

script-security 2
# run /etc/openvpn/up.sh when the connection is set up
up /storage/openvpn_up.sh
```
