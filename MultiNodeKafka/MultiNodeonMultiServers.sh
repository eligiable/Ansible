#!/bin/bash -e

E_NO_ARGS=65

function show_usage
{
    printf "Usage: `basename "$0"` [ansible-playbook arguments] \n\n"
    printf "Example: \n"
    printf "    `basename "$0"` kafka-installer.yml install\n"
    printf "    `basename "$0"` kafka-status.yml start\n\n"
    printf "Options: \n"
    printf "    kafka-installer.yml install|uninstall\n"
    printf "    kafka-status.yml start|stop|restart\n"

}   # end of show_usage

if [ $# -eq 0 ] || [ $# -eq 1 ]  # Must have at least 2 command-line arg(s).
then
  show_usage
  exit $E_NO_ARGS
fi

cd "$(dirname "$0")"

# multiple run_option available with kafka_installer: install, uninstall
#run_option=install
# multiple run_option available with kafka_status: stop, start, restart
#run_option=start

arg1="$1"
arg2="$2"
shift 2

set -x #echo on
#playbook_installer='kafka-installer.yml'
#playbook_status='kafka-status.yml'
hosts='./roles/kafka/hosts'
user='#Put Your Username here in single quotes'
target_hosts='kafka_hosts'

set -x #echo on
ansible-playbook ./roles/kafka/$arg1 \
                 -i $hosts \
                 -u $user \
                 --extra-vars "target_hosts=$target_hosts run_option=$arg2" \
                 "$@"
