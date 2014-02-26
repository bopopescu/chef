default[:news][:user]		='news'
default[:news][:group]		='news'
default[:news][:deployer]	='ihr-deployer'
default[:news][:news_path]	='/data/apps/newsletter'
default[:news][:error_log]	='/var/log/newsletter/newsletter_error.log'
default[:news][:repo]		='git@github.com:iheartradio/dfpemail.git'
default[:news][:rev]		='526561f3b4c5e6f228c2cd776f458fa78a76c552'
case chef_environment
when /^prod/
  default[:news][:mongo]    =[ 'iad-mongo-fac101-v240.ihr:37017', 'iad-mongo-fac102-v240.ihr:37017', 'iad-mongo-fac103-v240.ihr:37017' ]
when /^stage/
  default[:news][:mongo]	=[ 'iad-mongo-shared101-v240.ihr:37017', 'iad-mongo-shared102-v240.ihr:37017', 'iad-mongo-shared103-v240.ihr:37017' ]
end
default[:news][:secret_key]	='RedaaakyanRiWyedViaaarrUch'
