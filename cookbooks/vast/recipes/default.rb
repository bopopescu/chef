
#
# Cookbook Name:: vast
# Recipe:: default
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "tomcat7"
include_recipe "users::vast"
node.save

service "tomcat" do
  supports :start => true, :stop => true, :status => true
  action [:enable, :start]
end

remote_file "#{node[:tomcat7][:webapp_dir]}/vast.war" do
  Chef::Log.info("Installing vast.war from #{node[:vast][:url]}")
  source node[:vast][:url]
  owner node[:tomcat7][:user]
  group node[:tomcat7][:group]
  action :create_if_missing
  only_if "test -d #{node[:tomcat7][:webapp_dir]}"
  notifies :restart, "service[tomcat]", :immediately
end

directory "/var/run/tomcat" do
  owner node[:tomcat7][:user]
  group node[:tomcat7][:group]
  recursive true
end

template "#{node[:tomcat7][:install_path]}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner node[:tomcat7][:user]
  group node[:tomcat7][:group]
  mode "0755"
  variables({
              :tomcat_dir => node[:tomcat7][:install_path]
            })
end

cookbook_file "/data/apps/tomcat7/logs/archive_logs.sh"
  source "archive_logs.sh"
end

cron_d "archive_logs" do
  command "/data/apps/tomcat7/logs/archive_logs.sh"
  minute 0
  hour 23
  user "tomcat"
end
