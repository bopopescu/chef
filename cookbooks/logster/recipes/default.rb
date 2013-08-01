include_recipe "git"

package "logcheck"

include_recipe "logster::logrotate"


begin
  unless tagged?("logster-deployed")
    execute "git checkout logster" do
        command "git clone https://github.com/etsy/logster.git"
        creates "/var/tmp/logster"
        cwd "/var/tmp"
        action :run
        end

    directory "/usr/share/logster" do
        owner "root"
        group "root"
        mode "0755"
    end

    directory "/var/run/logster-state" do
        owner "root"
        group "root"
        mode "0755"
    end

    directory "/var/log/logster" do
        owner "root"
        group "root"
        mode "0755"
    end

    cron_d "logster-state" do
        minute  "1"
        hour    "0"
        mailto node['admin_email']
        command "find /var/run/logster-state -type f -mtime +1 -exec rm -f {} \\;"
    end

    # remove shitty logcheck cron that is broken on centos
    if File.exists?("/etc/cron.d/logcheck") then
        bash "delete" do
        code <<-EOF
            rm -f /etc/cron.d/logcheck
        EOF
        end
    end


    bash "install" do
        code <<-EOF
            cd /var/tmp/logster;
            python setup.py install
        EOF
      only_if "test -d /var/tmp/logster"
    end

    node[:logster][:static_files].each do |dest,src|
    cookbook_file "#{dest}" do
        source "#{src}"
        mode 0555
        end
    end

    tag("logster-deployed")
    end
rescue
    untag("logster-deployed")
end

