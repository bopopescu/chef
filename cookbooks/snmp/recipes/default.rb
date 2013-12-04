#
# Cookbook Name:: snmp
# Recipe:: default
#
# Copyright 2010, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node.run_list.include?("role[zeus]")
  Chef::Log.info("SNMPD does not work on zeus, bailing")
  return
end

node['snmp']['packages'].each do |snmppkg|
  package snmppkg
end

if not node['snmp']['cookbook_files'].empty?
  node['snmp']['cookbook_files'].each do |snmpfile|
    cookbook_file snmpfile do
      mode 0644
      owner "root"
      group "root"
    end
  end
end

# Host type should either be guest, i.e. VM, or metal, for a hardware server
host_type = node[:virtualization][:role] || "metal"

template "/etc/snmp/snmpd.conf" do
  source "snmpd.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[#{node['snmp']['service']}]"
end

service node['snmp']['service'] do
  action [ :start, :enable ]
end
