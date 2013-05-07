#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "postgresql::client"

# Create a group and user like the package will.
# Otherwise the templates fail.
include_recipe "postgresql::users"

node['postgresql']['server']['packages'].each do |pg_pack|

  package pg_pack

end

case node['platform_family']
when "rhel"
  case
  when node['platform_version'].to_f >= 6.0
    package "postgresql-server"
  else
    package "postgresql#{node['postgresql']['version'].split('.').join}-server"
  end
when "fedora", "suse"
  package "postgresql-server"
end

# Following not valid for 9.x version of postgresql
if node['postgresql']['version'].to_f < 9.0
  execute "/sbin/service postgresql initdb" do
    not_if { ::FileTest.exist?(File.join(node['postgresql']['dir'], "PG_VERSION")) }
  end
end

cookbook_file "/etc/init.d/postgresql-9.1" do
	source "postgresql-9.1"
	mode 0755
	action :create
end

link "/etc/init.d/postgres" do
	to "/etc/init.d/postgresql-9.1"
end

service "postgresql" do
  supports :restart => true, :status => true, :reload => true
  action [:stop,:disable]
end

file "/etc/init.d/postgresql" do
  action :delete
end

if not node.role?("postgres-server-ha")
  service "postgresql-9.1" do
    supports :restart => true, :status => true, :reload => true
    action [:enable]
  end
end
