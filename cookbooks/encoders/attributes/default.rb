#Place where application will live

# RPM's we need 
default[:pkgs686] = [  'libtool-ltdl-devel', 'alsa-lib',  'ncurses-libs', 'ncurses-devel', 'glibc', 'alsa-lib', 'libgcc', 'compat-libstdc++-33' ]
default[:pkgsx64] = [ 'libxml2', 'zlib', 'zlib-devel', 'libxml2-devel', 'libxslt', 'libxslt-devel' ]
# Iheart RPMS
default[:iheart_pkg] = [ 'jdk', 'mpg123',  'lame-libs', 'libmad-devel', 'libmad'  ]
default[:ftpserver] = [ 'vsftpd' ]

default[:vantrix] = [ 'spotxde-trx' ]




default[:jruby_gems] =  {
     "ruby-mp3info" => "0.7.1",
     "activerecord-jdbc-adapter" => "1.2.2",
     "jdbc-postgres" => "9.1.901",
     "activerecord-jdbcpostgresql-adapter" => "1.2.2",
     "tmail" => "1.2.7.1",
     "nokogiri" => "1.5.0",
     "rake" => "0.8.7",
     "uits" => "0.0.0",
     "bouncy-castle-java" => "1.5.0146.1",
     "jruby-openssl" => "0.7.7",
     "spoon" => "0.0.1",
     "bundler" => "1.1.5"
}

default[:gems] = {
    "akami" => "1.2.0",
    "ffi" => "1.2.0",
    "postgres-pr" => "0.6.3",
    "nori" => "2.0.4",
    "rack" => "1.5.2",
    "rails" => "3.2.13",
    "httpi" => "2.0.2",
    "wasabi" => "3.0.0",
    "builder" => "3.2.0",
    "gyoku" => "1.0.0",
    "akami" => "1.2.0",
    "savon" => "2.1.0",
    "libxml-ruby" => "2.6.0",
    "uits" => "0.0.0",
    "activerecord-jdbc-adapter" => "1.2.2",
    "activerecord-jdbcpostgresql-adapter" => "1.2.2",
    "bouncy-castle-java" => "1.5.0146.1",
    "bundler" => "1.1.5",
    "jdbc-postgres" => "9.1.901",
    "jruby-openssl" => "0.7.7",
    "nokogiri" => "1.5.0",
    "rake" => "0.8.7",
    "ruby-mp3info" => "0.7.1",
    "sources" => "0.0.1",
    "spoon" => "0.0.1",
    "tmail" => "1.2.7.1"
    }

default[:encoders][:static_files] = { 
    "/usr/local/bin/lame" => "lame",
    "/usr/local/bin/aacPlusEnc" => "aacPlusEnc",
    "/usr/local/bin/aacPlusDec" => "aacPlusDec",
    "/usr/local/bin/ffmpeg" => "ffmpeg"
}


default[:encoders][:deploy_path] = "/data/apps/converter" 
default[:encoders][:github_url] = "git@github.com:iheartradio/converter"
default[:encoders][:deploy_key] = "/home/converter/.ssh/encoder-deploy"
default[:encoders][:wrapper_script] = "encoder-wrap-ssh.sh"
default[:encoders][:converter_user] = "converter"
default[:encoders][:nfsserver] = "10.5.40.2"
default[:encoders][:ftp_mount] = "/data/encoder-ftp"
default[:encoders][:encoder_mount] = "/data/encoder"
default[:encoders][:aladdin_mount_dir] = "/data/aladdin"
default[:encoders][:aladdin_export_dir] = "/radioutils/aladdin"
default[:encoders][:prn_mount_dir] = "/data/prn"
default[:encoders][:prn_export_dir] = "/prn"

default[:encoders][:user] = "converter"
default[:encoders][:ftpuser] = "ftp"
default[:encoders][:group] = "converter"

default[:encoders][:logdir] = "/data/logs/manager"

default[:encoders][:filemonitor][:logdir] = "/var/log/filemonitor"

# ingestion variables
default[:encoders][:filemonitor][:ingester_war] = "ingester.war"
default[:encoders][:filemonitor][:postgres_jar] = "postgresql-9.0-801.jdbc4.jar"

default[:encoders][:filemonitor][:static_files] = { 
    "/data/apps/filemonitor" => "filemonitor"
}
# talk links
default[:encoders][:filemonitor][:talk_links] = { 
    "/PRN" => "/data/prn"
}

# ingestion links
default[:encoders][:filemonitor][:ingestion_links] = { 
    "/talk" => "/data/encoder/tmp-ingestion/talk/prod",
    "/Talk" => "/data/encoder/tmp-ingestion/Talk",
    "/Talk_Audio" => "/data/encoder/tmp-ingestion/Talk_Audio",
    "/Utility" => "/data/encoder/tmp-ingestion/Utility"
}
