#
# Cookbook Name:: monitoring
# Recipe:: dell
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

# All the rpms are in our iheart/dell repo
# Do not install repos, ever.  we don't trust them that much

case node['platform_family']
when "rhel"
  package "srvadmin-all"
  package "perl-Net-SNMP"

  link "/etc/init.d/dell-omsa" do
    to "#{node[:dell][:omsa][:path]}/sbin/srvadmin-services.sh"
  end

  service "dell-omsa" do
    supports :start => true
    action :start
  end
end
omreport = "#{node[:dell][:omsa][:path]}/bin/omreport"

sudo "nagios" do
  user "nagios"
  commands [ "#{omreport}" ]
  nopasswd true
end

nagios_nrpecheck "Dell-Performance-Profile" do
  command "sudo #{omreport} chassis biossetup | grep 'System Profile' | egrep 'Performance$|Custom$' && echo $?"
end

unless node.run_list.include?("role[dell]")
  node.run_list << "role[dell]"
end

nagios_nrpecheck "Dell-Omsa-Check" do
  command "#{node['nagios']['plugin_dir']}/check_openmanage.pl --only esmlog"
end
