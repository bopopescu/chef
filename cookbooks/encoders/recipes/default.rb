#
# Cookbook Name:: encoder
# Recipe:: default
#
# Copyright 2013, iheartradio / clear channel
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

enc_data = Chef::EncryptedDataBagItem.load("secrets", "github")


node[:pkgs686].each do |pkg|
  yum_package pkg do
    arch "i686"
    not_if { node.normal.attribute?("encoder_deployed") }
  end
end

node[:pkgsx64].each do |pkg|
  yum_package pkg do
    arch "x86_64"
    not_if { node.normal.attribute?("encoder_deployed") }
  end
end

node[:iheart_pkg].each do |ihr_pkg|
  package ihr_pkg do
    action :install
    not_if { node.normal.attribute?("encoder_deployed") }
  end
end

node[:gems].each do |gem,ver|
  gem_package "#{gem}" do
    action :install
    options "--no-ri --no-rdoc"
    version "#{ver}"
#    not_if { node.normal.attribute?("encoder_deployed") }
  end
end

node[:jruby_gems].each do |gem,ver|
  bash "install_jruby" do
     code <<-EOF
         jruby -S gem install #{gem} -v #{ver} 
     EOF
     not_if { node.normal.attribute?("encoder_deployed") }
  end
end

node[:encoders][:static_files].each do |dest,src|
  cookbook_file "#{dest}" do
    source "#{src}"
    mode 0555
    not_if { node.normal.attribute?("encoder_deployed") }
    end
end


# doing this as a bash block, because apparently you can't link directories 
# natively
bash "link_jdk" do 
    code <<-EOF
        ln -s /usr/java/jdk1.6.0_26/ /usr/bin/jdk
    EOF
    not_if { node.normal.attribute?("encoder_deployed") }
end

#private_key = "/home/#{node[:encoders][:github_user]}/.ssh/id_rsa"
#
#file private_key do
#    owner "github"
#    group "github"
#    mode "0400"
#    action :create
#    content enc_data["private_key"]
#    not_if { node.normal.attribute?("encoder_deployed") }
#end

bash "github checkout" do
    code <<-EOF
        if [ ! -x #{node[:encoders][:source_dir]} ]
            then
                mkdir -p #{node[:encoders][:source_dir]}
                chown #{node[:encoders][:converter_user]}.#{node[:encoders][:converter_user]}  #{node[:encoders][:source_dir]}
            fi
        if [ ! -L #{node[:encoders][:source_dir]} ]
            then
                ln -s #{node[:encoders][:source_dir]} /home/#{node[:encoders][:converter_user]}
        fi
#        su #{node[:encoders][:converter_user]} -c 'cd #{node[:encoders][:source_dir]}; git clone #{node[:encoders][:github_url]}'
    EOF
#    not_if { node.normal.attribute?("encoder_deployed") }
end

mount_line = "#{node[:encoders][:nfsserver]}:/nfs#{node[:encoders][:ftpmount]} #{node[:encoders][:ftpmount]}       nfs   rw,bg,soft,tcp,intr  0   0"

execute "mkdirs" do
    command "mkdir #{node[:encoders][:ftpmount]}"
    not_if { ::File.exists?("#{node[:encoders][:ftpmount]}")}
end

execute "mounts" do
    command "/bin/mount -a"
    action :run
end

append_if_no_line "encoder_ftp" do
    path "/etc/fstab"
    line mount_line
    notifies :run, "execute[mkdirs]", :immediately
    notifies :run, "execute[mounts]", :immediately
end

ruby_block "deployed_flag" do
  block do
    node.set['encoder_deployed'] = true
    node.save
  end
end
