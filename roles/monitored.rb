name "monitored"
description "Sets up Nagios, Rsyslog, Ganglia"
run_list(
         "recipe[nagios]",
         "recipe[diamond]",
         "recipe[monitoring]",
         "recipe[nagios-api::client]",
         "recipe[snmp]"
)
