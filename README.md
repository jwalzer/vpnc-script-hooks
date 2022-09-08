# vpnc-script-hooks

These scripts helped me debugging, troubleshooting and extending the vpnc-script.

It is a collection of some general hooks, that can/should be symlinked and allow
some kind of "small" configuration of additional steps on a per host basis.


Why: It is common, that policies get pushed down to the vpn-clients to hijack the
default route of a system and shovel everything through a vpn.
This would be fine, if the traffic would be passing through the vpn. But some
vpns are setup in a way that the local client is then completely isolated from
the rest of the internet, making it difficult to use.

vpnc-script correctly applies these pushed down routes and does its job as expected,
but sometimes it is neccessary, on a by_host basis to correct such stuff

## usage

you have to place all the stuff in `/etc/vpnc` because thats where the vpnc-script looks for hooks by default.

The file `05_environment_hook.sh` converts all the Cisco CSTP Options into environment variables, to use in your script.

The file `50_opt_hooks.sh` delivers some standard functions used to setup networking.
This part is mostly work-in-progress and in a works-for-me state.
Additionally this file will call host-specific setup scripts which are stored below the `by_host` directory.

## examples

There are currently two directories supplied, but others can be symlinked yourself.
In `connect.d` you can see a subdirectory `by_host`. An example config that is used to connect to `vpn.example.com` has to be saved there with exactly this domain name.

```
  echo "called hook for vpn.example.com ... starting async setup"

  (
    sleep 10
    echo "DBG: Delayed thread for example woken up..."
    my_gateway="$(hook_get_local_gateway_from_vpn_endpoint)"

    hook_remove_global_vpn_route
    hook_set_default_route "$my_gateway"

  #
  # here you specify which networks should be reachable behind the vpn
  # (multiple calls possible)

    hook_set_vpn_route 10.0.0.0/8
    hook_set_vpn_route 10.3.0.1/32
  #
  #

    hook_activate_masquerading

    ip route
  ) &

```

This script finds the "old" Default-Gateway, removes the default route that pushes all traffic through the VPN. Installs a new default route through the "old" default gateway and adds additional routes for the 10.0.0.0/8 range into the vpn.
At the end it activates masquerading for everything that goes into the vpn network interface.

The whole script is encapsulated into an asyncronous shell-thread, that waits 10 seconds and then works in the background. This is, to avoid some race-conditioning.

