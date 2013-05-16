# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nfs"

nfs_server = search(:node, "roles:loghost AND chef_environment:#{node.chef_environment}")[0]
if nfs_server.nil? or nfs_server.empty?
  Chef::Log.info("No shared-storage found in #{node.chef_environment}")
  return
end

directory "/data/#{nfs_server[:hostname]}/logs" do
  action :create
  recursive true
end

mount "/data/#{nfs_server[:hostname]}/logs" do
  device "#{nfs_server[:hostname]}-v600.ihr:/data/logs"
  fstype "nfs"
  options "noatime,nocto"
  action [:mount, :enable]
end
