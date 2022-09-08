echo "called disconnect hook for vpn.example.com ... starting async unsetup"

(
  echo "DBK: Delayed thread for example.com woken ..."
  hook_remove_masquerading
  ip route
) &