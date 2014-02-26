name             'shared-web'
maintainer       'iHeartRadio'
maintainer_email 'none@none.com'
license          'All rights reserved'
description      'Installs/Configures shared-web'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w{ nagios tomcat7 apache2 }.each do |dep|
  depends dep
end

%w{ centos debian }.each do |os|
  supports os
end

%w{ ops.ihrdev.com files.ihrdev.com ipplan www.thumbplay.com roku.iheart.com }.each do |site|
  depends site
end
