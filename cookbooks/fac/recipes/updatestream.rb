#
# Cookbook Name:: fac
# Recipe:: updatestream
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#


app = "updatestream"
script_dir = "#{node[:fac][:script_path]}/#{app}"

%w{ python-xlrd }.each do |p|
  package p
end

directory "#{script_dir}" do
  recursive true
end

# drop a github private deploy key for attivio
deploy_keys = Chef::EncryptedDataBagItem.load("keys", "amp-tools")

directory "/root/.ssh" do
  mode "0700"
end

file "/root/.ssh/deploy" do
  owner "root"
  group "root"
  mode "0400"
  content deploy_keys['private_key']
  :create_if_missing
end

file "/root/.ssh/config" do
  owner "root"
  group "root"
  mode "0755"
  content <<-EOH
  Host *github.com
    IdentityFile "/root/.ssh/deploy"
    StrictHostKeyChecking no
EOH
end

git "#{script_dir}" do
  repository node[:fac][:amptools][:repo]
  revision "HEAD"
  action :sync
end

directory "#{script_dir}/streaminfo/output" do
  owner "nobody"
  group "nobody"
  mode "0755"
end

template "#{script_dir}/streaminfo/updatestream.conf" do
  source "updatestream.conf.erb"
  owner "nobody"
  group "nobody"
  mode "0755"
  variables({
              :basedir => "#{script_dir}/streaminfo",
              :list_attivio => "#{script_dir}/streaminfo/output/streams_list_attivio_ready.xml"
            })
end

file "/var/log/fac-#{app}" do
  owner "nobody"
  group "nobody"
  mode "0775"
end

cron_d "fac-updatestream" do
  minute "0"
  hour "*/4"
  command "cronwrap iad-jobserver101 fac-updatestream \"#{script_dir}/streaminfo/updateStream.sh\" 2>&1 > /var/log/fac-#{app}"
  user "nobody"
end

master = search(:node, "recipes:attivio\\:\\:clustermaster AND chef_environment:#{node.chef_environment}")

template "#{script_dir}/streaminfo/ship2attivio.sh" do
  source "ship2attivio.sh.erb"
  owner node[:attivio][:user]
  group node[:attivio][:group]
  mode "0755"
  variables({
              :updatestream => "#{script_dir}/streaminfo",
              :attivio_master => master[0],
              :attivio_dropbox => "#{node[:attivio][:input_path]}/xml/station/update/"
            })
end
cron_d "fac-updatestream-ship2attivio" do
  minute "5"
  user "attivio"
  command "/usr/bin/cronwrap iad-jobserver101 fac-updatestream-ship2attivio \"#{script_dir}/streaminfo/ship2attivio.sh\""
end
