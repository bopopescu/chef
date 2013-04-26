#
# Cookbook Name:: amp
# Recipe:: default
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "users::amp"
include_recipe "tomcat7"

node.set[:java][:oracle][:accept_oracle_download_terms] = true
node.save
include_recipe "java"

hosts = Hash.new
hosts["mongodb-fac1b01"] = "10.90.47.182"
hosts["mongodb-fac1b02"] = "10.90.47.183"
hosts["mongodb-fac1b03"] = "10.90.47.184"
hosts["mongodb-fac1b04"] = "10.90.47.185"
hosts["cassandra1a01"] = "10.90.49.240"
hosts["cassandra1a02"] = "10.90.49.241"
hosts["cassandra1a03"] = "10.90.49.242"
hosts["cassandra1a04"] = "10.90.49.243"
hosts["cassandra1a05"] = "10.90.49.251"

hosts.each do |host,ip|
  hostsfile_entry ip do
    hostname host
  end
end

service "tomcat" do
  supports :start => true, :stop => true, :status => true
  action [:enable, :start]
end

begin
  puts "entered begin block"
  unless node[:amp][:deployed] == node[:amp][:version]
    puts "INSTALLING AMP DERP DERP"
    service "tomcat" do
      action :stop
    end

    remote_file "#{node[:tomcat7][:webapp_dir]}/amp-rest.war" do
      source "#{node[:amp][:url]}/#{node[:amp][:version]}/amp-rest-#{node[:amp][:version]}.war"
      owner node[:tomcat7][:user]
      group node[:tomcat7][:group]
      mode "0755"
    end

    remote_file "#{node[:tomcat7][:install_path]}/lib/env.properties" do
      source "#{node[:amp][:url]}/#{node[:amp][:version]}/env.properties"
      owner node[:tomcat7][:user]
      group node[:tomcat7][:group]
      mode "0755"
    end

    remote_file "#{node[:tomcat7][:install_path]}/lib/log4j.xml" do
      source "#{node[:amp][:url]}/#{node[:amp][:version]}/log4j.xml"
      owner node[:tomcat7][:user]
      group node[:tomcat7][:group]
      mode "0755"
    end

    service "tomcat" do
      action [:enable, :start]
    end

    node.set[:amp][:deployed] = node[:amp][:version]
    node.save
  end
rescue
  node.set[:amp][:deployed] = "false"
end

service "tomcat" do
  action [:enable, :start]
end
