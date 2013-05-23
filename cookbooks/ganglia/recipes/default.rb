#
# Cookbook Name:: ganglia
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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

case node[:platform]
when "ubuntu", "debian"
  package "ganglia-monitor"
when "redhat", "centos", "fedora"
  include_recipe "host-sflow"
  include_recipe "ganglia::source"

  template "/etc/init.d/ganglia-monitor" do
    source "ganglia-monitor.init.erb"
    owner "root"
    group "root"
    mode "0755"
  end

  user "ganglia"
end

directory "/etc/ganglia"

case node[:ganglia][:unicast]
when true
  host = search(:node, "role:#{node['ganglia']['server_role']}").map {|node| node.ipaddress}
  if host.empty?
    host = "127.0.0.1"
  end
  cluster_name = node[:ganglia][:cluster_name].downcase
  puts "constructing ganglia cluster #{cluster_name}"
  cluster = search(:ganglia, "id:#{cluster_name}")
  template "/etc/ganglia/gmond.conf" do
    source "gmond_unicast.conf.erb"
    variables({
                :cluster_name => cluster_name,
                :host => host.first,
                :cluster => cluster.first
                })
    notifies :restart, "service[ganglia-monitor]"
  end
when false
  cluster_name = node[:ganglia][:cluster_name].downcase
  puts "constructing ganglia cluster #{cluster_name}"
  cluster = search(:ganglia, "id:#{cluster_name}")
  puts "#{cluster_name}: " + cluster.inspect
  template "/etc/ganglia/gmond.conf" do
    source "gmond.conf.erb"
    variables({
                :cluster_name => cluster_name,
                :cluster => cluster.first
              })
    notifies :restart, "service[ganglia-monitor]"
  end
end

directory "/usr/local/lib64/ganglia/python_modules" do
  owner "ganglia"
  group "ganglia"
  recursive true
end

service "ganglia-monitor" do
  pattern "gmond"
  supports :restart => true
  action [ :enable, :start ]
end
