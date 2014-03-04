#
# Cookbook Name:: elasticsearchnew
# Recipe:: default
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#
unless tagged?('elasticsearchnew-deployed')
  %w{ 
      users::elasticsearch 
      elasticsearchnew::users 
      users::deployer 
      elasticsearchnew::elasticsearch 
    }.each do |cb|
    include_recipe cb
  end

  if /prod/ =~ node.chef_environment
    include_recipe "elasticsearchnew::backup_client"
  end
  
  %w{ configs data input logs }.each do |der|
    directory "#{node[:elasticsearchnew][:ihrsearch_path]}/#{der}" do
      owner node[:elasticsearchnew][:user]
      group node[:elasticsearchnew][:group]
      recursive true
    end
  end
  
  pkg = "configs.tgz"
  
  execute "chown-ihr-search-configs" do
    command "chown -R #{node[:elasticsearchnew][:user]}.#{node[:elasticsearchnew][:group]} #{node[:elasticsearchnew][:ihrsearch_path]}"
    action :nothing
  end

  execute "Untar-ihr-search-configs" do
    command "rm -rf #{node[:elasticsearchnew][:ihrsearch_path]}/configs.bak; mv #{node[:elasticsearchnew][:ihrsearch_path]}/configs #{node[:elasticsearchnew][:ihrsearch_path]}/configs.bak; mkdir #{node[:elasticsearchnew][:ihrsearch_path]}/configs; tar zxf #{pkg} -C #{node[:elasticsearchnew][:ihrsearch_path]}/configs"
    cwd Chef::Config[:file_cache_path]
    action :nothing
    notifies :run, resources(:execute => "chown-ihr-search-configs"), :immediately
    user node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end
  
  remote_file "#{Chef::Config[:file_cache_path]}/#{pkg}" do
    source "#{node[:elasticsearchnew][:url]}/#{node.chef_environment}/es-configs/#{pkg}"
    notifies :run, resources(:execute => "Untar-ihr-search-configs"), :immediately
    owner node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end

  remote_file "#{node[:elasticsearchnew][:input_path]}/t3/zip_to_market.csv" do
    source "#{node[:elasticsearchnew][:url]}/#{node[:chef_environment]}/zip_to_market.csv"
    owner node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end

  template "/etc/init.d/elasticsearch" do
    source "elasticsearch.init.erb"
    owner "root"
    group "root"
    mode "0755"
    notifies :restart, "service[elasticsearch]"
  end

  bash "install-elasticsearch-service" do
    code "chkconfig --add elasticsearch"
    not_if "chkconfig --list | egrep '^elasticsearch'"
  end
  
  service "elasticsearch" do
    supports :start => true, :stop =>true, :restart => true
    action :start
  end
  
  cluster_members = search(:node, "cluster_name:#{node[:elasticsearchnew][:cluster_name]}")
  
  cluster_ips = Array.new
  cluster_members.each do |s|
    #cluster_ips << s["network"]["interfaces"]["eth0"]["addresses"].to_hash.select {|addr, info| info["family"] == "inet"}.flatten.first
    cluster_ips << s[:ipaddress]
  end
  
  template "#{node[:elasticsearchnew][:ihrsearch_path]}/configs/elasticsearch.yml" do
    source "elasticsearch.yml.erb"
    owner node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
    variables({
                :cluster_ips => cluster_ips.join(',')
               })
    notifies :restart, "service[elasticsearch]"
  end
  
  template "#{node[:elasticsearchnew][:ihrsearch_path]}/configs/logging.yml" do
    source "logging.yml.erb"
    owner node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end
  
  dwh_creds = Chef::EncryptedDataBagItem.load("secrets", "dwh_radiomodel_creds")
  ing_creds = Chef::EncryptedDataBagItem.load("secrets", "ing_db_creds")
  template "#{node[:elasticsearchnew][:ihrsearch_path]}/configs/index-builder.properties" do
    source "index-builder.properties.erb"
    owner node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
    variables({  
                :dwh_radiomodel_creds => dwh_creds,
		        :ing_db_creds => ing_creds
              })

  end
  tag('elasticsearchnew-deployed')
end
