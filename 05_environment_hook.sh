#!/bin/sh

#
# what an uggly hackery, just to get this done in /bin/sh

#
# This is used to convert the Options in CISCO_CSTP_OPTIONS into
# valid environment variables, with a prefix "OC_"
# later we can access these variables
#

while IFS="=" read -r VARNAME VARVALUE
    do
        case "$VARNAME" in
            X-CSTP-*)
                NEWVARNAME="OC_$(echo "$VARNAME" | tr '-' '_')"
                export "${NEWVARNAME}=$VARVALUE"
                ;;
        esac
    done <<EOT
${CISCO_CSTP_OPTIONS}
EOT

