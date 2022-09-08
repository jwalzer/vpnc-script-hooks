#
#  global general hook collector file
#
#  the idea is, to define functions here, that can
#  be called globally, or by dedicated per_??? basis
#
#  ie: we can have a by_host config which restores networking
#

hook_get_local_gateway_from_vpn_endpoint() {
  read -r EndPoint _via GateWay _dev DEVice _rest <<EOT
$(ip route get "$VPNGATEWAY" | grep "$VPNGATEWAY" | head -n 1 )
EOT
echo $GateWay
}

hook_remove_global_vpn_route() {
  echo "removing global vpn route"
  ip ro del default dev $TUNDEV 2>&1
}

hook_set_default_route() {
  echo "setting the set_default_route to $1"
  ip route add default via $1 2>&1
}

hook_set_vpn_route() {
  echo "setting Route into VPN: $1 dev $TUNDEV"
  echo ip route add "$1" dev "$TUNDEV"
  ip route add "$1" dev "$TUNDEV" 2>&1
}

hook_activate_masquerading() {
  echo "activating masquerading behind dev $TUNDEV"
  iptables -t nat -A POSTROUTING -o $TUNDEV -j MASQUERADE
}

hook_remove_masquerading() {
  echo "activating masquerading behind dev $TUNDEV"
  iptables -t nat -A POSTROUTING -o $TUNDEV -j MASQUERADE
}

[ -r "${HOOKS_DIR}/${HOOK}.d/by_host/${OC_X_CSTP_Hostname}" ] && . "${HOOKS_DIR}/${HOOK}.d/by_host/${OC_X_CSTP_Hostname}"