name             'flume-ng'
maintainer       'iHeartRadio'
maintainer_email 'pkatsev@clearchannel.com'
license          'All rights reserved'
description      'Installs/Configures flume-ng'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w{ centos debian }.each do |os|
  supports os
end

%w{ users tomcat7 java nagios }.each do |dep|
  depends dep
end
