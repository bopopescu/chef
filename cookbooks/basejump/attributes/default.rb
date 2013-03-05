
default[:basejump][:db_name] = "basejump"
default[:basejump][:app_name] = "basejump"
default[:basejump][:db_user] = "basejump"
default[:basejump][:tools_user] = "basejumper"

#default[:basejump][:repo] = "https://github.com/iheartradio/basejump.git"
# save me time merging downstream until I get this right
default[:basejump][:repo] = "https://github.com/kplimack/basejump.git"
default[:basejump][:rev] = "HEAD"

default[:basejump][:kickstarter][:tftp_root] = '/data/tftpboot'

case node['platform']
when "debian","ubuntu"
  default['basejump']['packages'] = %w[ python-mysqldb libmysqlclient-dev xinetd tftpd syslinux ]
when "redhat","centos","scientific","amazon"
  default['basejump']['packages'] = %w[ MySQL-python mysql-devel syslinux ]
end

default[:basejump][:kickstarter][:syslinux_url] = "http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-5.01.tar.gz"
default[:basejump][:kickstarter][:syslinux_links] = ({
                                                       "ldlinux.c32" => "syslinux-5.01/com32/elflink/ldlinux/ldlinux.c32",
                                                       "libutil.c32" => "syslinux-5.01/com32/libutil/libutil.c32",
                                                       "pxelinux.0" => "syslinux-5.01/core/pxelinux.0",
                                                       "modules/vesamenu.c32" => "syslinux-5.01/com32/menu/vesamenu.c32",
                                                       "modules/menu.c32" => "syslinux-5.01/com32/menu/menu.c32",
                                                       "modules/reboot.c32" => "syslinux-5.01/com32/modules/reboot.c32",
                                                       "libcom32.c32" => "syslinux-5.01/com32/lib/libcom32.c32"
                                                      })

default[:basejump][:kickstarter][:flavors] = ({
                                                "centos" => %w{ 6.3 }
                                              })
default[:basejump][:kickstarter][:mirrors] = ({
                                                "centos" => "http://mirror.stanford.edu/yum/pub/"
                                              })
