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
