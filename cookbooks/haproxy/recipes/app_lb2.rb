#
# Cookbook Name:: haproxy
# Recipe:: app_lb
#
# Copyright 2011, Opscode, Inc.
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

pool_members = search("node", "role:#{node['haproxy']['app_server_role']} AND chef_environment:#{node.chef_environment}") || []

# load balancer may be in the pool
pool_members << node if node.run_list.roles.include?(node['haproxy']['app_server_role'])

# we prefer connecting via local_ipv4 if 
# pool members are in the same cloud
# TODO refactor this logic into library...see COOK-494
pool_members.map! do |member|
  server_ip = begin
    if member.attribute?('cloud')
      if node.attribute?('cloud') && (member['cloud']['provider'] == node['cloud']['provider'])
         member['cloud']['local_ipv4']
      else
        member['cloud']['public_ipv4']
      end
    else
      member['ipaddress']
    end
  end
  {:ipaddress => server_ip, :hostname => member['hostname']}
end

package "haproxy" do
  action :install
end

# grab the backends except the common which we do later
results = search(:loadbalancer, "NOT id:common")
backends = Array.new
results.each do |svc|
  svc['backends'].each do |be|
    Chef::Log.info("Searching for: " + "name:#{be['server']}")
    servers = search(:node, "name:#{be['server']}")
    servers.each do |s|
      Chef::Log.info(JSON::dump(s))
      be['ipaddress'] = s['ipaddress']
    end
  end
  backends << svc
end

template "/etc/default/haproxy" do
  source "haproxy-default.erb"
  owner "root"
  group "root"
  mode 0644
end


result = data_bag_item('loadbalancer', 'common')
def_backends = result['backends']

# this will return a hash (object) of arrays (backends) of hashes (backend details)
# there is definitely a cleaner way to do this
# ***refactorme***

default_backend = Hash.new
default_backend['name'] = "use1b-ss-web"
default_pool = Array.new
default_options = Array.new
def_backends.values.each do |backend|
  backend.each do |b|
    servers = search(:node, "name:#{b['server']}")
    servers.each do |s|
      b['ipaddress'] = s['ipaddress']
    end
    default_pool << b
  end
end
default_backend['pool'] = default_pool
default_backend['options'] = result['options']

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy-app_lb2.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables ({
               :pool_members => pool_members.uniq,
               :default_backend => default_backend,
               :backends => backends
             })
  notifies :restart, "service[haproxy]"
end

cookbook_file "/etc/rsyslog.d/haproxy.conf" do
  source "haproxy.conf"
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
  only_if "test -d /etc/rsyslog.d"
  notifies :restart, "service[rsyslog]"
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
