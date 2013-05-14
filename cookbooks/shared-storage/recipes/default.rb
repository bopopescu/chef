#
# Cookbook Name:: shared-storage
# Recipe:: default
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nfs::server"

directory node[:sto][:base_path] do
  recursive true
end

%w{ files.ihrdev.com::nfs }.each do |share|
  include_recipe share
end
