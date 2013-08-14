#
# Cookbook Name:: fac
# Recipe:: prn
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

# this is to setup keys for shipping files
include_recipe "attivio::users"

app = 'radiobuild2'
download_url = "#{node[:fac][:radiobuild2][:url]}/radio-build/#{node[:fac][:radiobuild2][:version]}/radio-build-#{node[:fac][:radiobuild2][:version]}.jar"
script_dir = "#{node[:fac][:script_path]}/#{app}"

%w{ input output }.each do |der|
  directory "#{script_dir}/#{der}" do
    recursive true
  end
end

remote_file "#{script_dir}/fac-#{app}.jar" do
  Chef::Log.info("Downloading fac-#{app} from #{download_url}")
  source "#{download_url}"
  mode "0755"
  action :create_if_missing
end

# init directories
%w{ /var/run/fac }.each do |dir|
  directory dir do
    recursive true
    mode "0755"
  end
end

directory "/var/log/fac-#{app}" do
  recursive true
  mode "0755"
end

bash "Download RadioBuild:Echonest" do
    cwd "#{script_dir}/input"
    code "wget #{node[:fac][:radiobuild2][:echonest]}"
    not_if "test -f #{script_dir}/input/ten.915.gz"
end

template "/etc/init.d/fac-#{app}" do
  source "fac.init.erb"
  mode "0755"
  owner "root"
  group "root"
  variables({
              :fac_app => app,
              :jarfile => "#{script_dir}/fac-#{app}.jar"
            })
end
