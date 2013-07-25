#
# Cookbook Name:: encoder
# Recipe:: default
#
# Copyright 2013, iheartradio / clear channel
#
# All rights reserved - Do Not Redistribute
#

%w{ users::converter }.each do |r|
  include_recipe r
end

begin 
  unless tagged?("encoder-deployed")

    node[:pkgs686].each do |pkg|
      yum_package pkg do
        arch "i686"
      end
    end

    node[:pkgsx64].each do |pkg|
      yum_package pkg do
        arch "x86_64"
      end
    end

    node[:iheart_pkg].each do |ihr_pkg|
      package ihr_pkg do
        action :install
      end
    end

    node[:gems].each do |gem,ver|
      gem_package gem do
        action :install
        options "--no-ri --no-rdoc"
        version ver
      end
    end

    node[:jruby_gems].each do |gem,ver|
      bash "install_jruby" do
         code <<-EOF
             jruby -S gem install #{gem} -v #{ver} 
         EOF
      end
    end

    node[:encoders][:static_files].each do |dest,src|
      cookbook_file dest do
        source src
        mode 0555
        end
    end

    cookbook_file "/home/converter/encoder-wrap-ssh.sh" do
        source node[:encoders][:wrapper_script]
        mode 0755
        action :create_if_missing
    end


    application "converter" do
        path "#{node[:encoders][:deploy_path]}"
        deploy_key "encoder_deploy"
        repository node[:encoders][:github_url]
        revision "master"
    end

    deploy "converter" do
        repo node[:encoders][:github_url]
        symlink_before_migrate.clear
        create_dirs_before_symlink.clear
        purge_before_symlink.clear
        symlinks.clear
        user "converter"
        deploy_to "#{node[:encoders][:deploy_path]}"
        action :deploy
        ssh_wrapper "/home/converter/encoder-wrap-ssh.sh"
    end

# doing this as a bash block, because apparently you can't link directories 
# natively
    bash "link_jdk" do 
        code <<-EOF
            ln -s /usr/java/jdk1.6.0_26/ /usr/bin/jdk
        EOF
        not_if { ::File.exists?("/usr/java/jdk1.6.0_26") } 
    end

#    ftp_mount_line = "#{node[:encoders][:nfsserver]}:/nfs#{node[:encoders][:ftp_mount]} #{node[:encoders][:ftp_mount]}       nfs   rw,vers=3,bg,soft,tcp,intr  0   0"
#    encoder_mount_line = "#{node[:encoders][:nfsserver]}:/nfs#{node[:encoders][:encoder_mount]} #{node[:encoders][:encoder_mount]}       nfs   rw,vers=3,bg,soft,tcp,intr  0   0"

#    execute "mkdirs" do
#        command "mkdir -p #{node[:encoders][:ftp_mount]}"
#        not_if { ::File.exists?(node[:encoders][:ftp_mount])}
#    end
#
#    execute "mkdirs2" do
#        command "mkdir -p #{node[:encoders][:encoder_mount]}"
#        not_if { ::File.exists?(node[:encoders][:encoder_mount])}
#    end
#
#    execute "logdir" do
#        command "mkdir -p #{node[:encoders][:logdir]}"
#        not_if { ::File.exists?(node[:encoders][:logdir])}
#    end

#    execute "mounts" do
#        command "/bin/mount -a"
#        action :run
#    end

#    append_if_no_line "encoder_mount" do
#        path "/etc/fstab"
#        line encoder_mount_line
#        notifies :run, "execute[mkdirs2]", :immediately
#        notifies :run, "execute[mounts]", :immediately
#    end
#
#    append_if_no_line "encoder_ftp" do
#        path "/etc/fstab"
#        line ftp_mount_line
#        notifies :run, "execute[mkdirs]", :immediately
#        notifies :run, "execute[mounts]", :immediately
#    end

    bash 'extract_sox' do
    code <<-EOH
        cd /tmp
        wget http://files.ihrdev.com/sox.tar.gz
        cd /
        tar xvzf /tmp/sox.tar.gz
        rm /tmp/sox.tar.gz
    EOH
    end

    tag("encoder-deployed")
    end
rescue
    untag("encoder-deployed")
end

