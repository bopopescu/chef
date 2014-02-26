#
# Cookbook Name:: fac
# Recipe:: updatestream
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "elasticsearch::users"
include_recipe "users::deployer"
app = "updatestream"
script_dir = "#{node[:fac][:script_path]}/#{app}"

%w{ python-xlrd }.each do |p|
  package p
end

directory "#{script_dir}" do
  recursive true
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

# GP 9/24/13 - updated. replaced cronwrap command with nsca_relay
# JPD Tue Oct  1 19:51:09 UTC 2013 -- removed per OPS-5580
# cron_d "fac-updatestream" do
#  minute "0"
#  hour "*/4"
#  command "/usr/bin/nsca_relay -S fac-updatestream -- #{script_dir}/streaminfo/updateStream.sh 2>&1 > /var/log/fac-#{app}"
#  user "root"
#end

master = search(:node, "tags:es_master AND role:elasticsearchnew")

template "#{script_dir}/streaminfo/ship2es.sh" do
  source "ship2es.sh.erb"
  owner node[:elasticsearch][:user]
  group node[:elasticsearch][:group]
  mode "0755"
  variables({
              :updatestream => "#{script_dir}/streaminfo",
              :es_master => "#{node[:fac][:es_vip]}",
              :es_dropbox => "#{node[:elasticsearch][:input_path]}/livestations"
            })
end

cron_d "fac-updatestream-t3dump" do
  minute "35"
  hour "3"
  weekday "4"
  user "nobody"
  if tagged?("no-updatestream")
    command "#/usr/bin/cronwrap iad-jobserver101a fac-updatestream-t3dump \"#{script_dir}/streaminfo/zip/t3_dump_zip.py"
  else
    command "/usr/bin/cronwrap iad-jobserver101a fac-updatestream-t3dump \"#{script_dir}/streaminfo/zip/t3_dump_zip.py"
  end
end
