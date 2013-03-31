#!/usr/bin/env python
import sys
from subprocess import Popen, PIPE, STDOUT

# This is a simple script that formats text and pipes it to send_nsca

# the hostname must be specified so that we can monitor VIPs of Artive/Passive HA-clusters
# we assume that you've used cronwrap which will call this script properly.

if len(sys.argv) < 5:
    print "Usage: " + sys.argv[0] + " <hostname> <check> <value> <text>"
    sys.exit(1)
else:
    print "argv = %s" % len(sys.argv)

# we may need have chef plug in all the nagios servers and send them all this update
nagios_server="nagios-iad.ihrdev.com"
send_nsca='/usr/lib/nagios/plugins/send_nsca'
nsca_conf='/etc/nagios/send_nsca.conf'
check_host = sys.argv[1]
check_name = sys.argv[2]
check_result = sys.argv[3]
check_msg = sys.argv[4]

# send_nsca must be formated as: send_nsca <nagios_server> -c <nsca.conf> "<hostname>\t<check>\t<result>\t<msg>"

cmd= "%s %s -c %s" % (send_nsca, nagios_server, nsca_conf)
msg="\t".join(sys.argv[1:])
full_cmd = "echo \"%s\" | %s" % (msg, cmd)
p = Popen(full_cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
output = p.stdout.read()
print output
