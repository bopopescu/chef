

include_recipe "ingestion::ulimits"
include_recipe "ingestion::sysctl"
include_recipe "php"
include_recipe "multipath"
include_recipe "bonded_interfaces"
