name "base"
description "common role applied to all nodes"
all_env = [
           "recipe[resolver]",
           "recipe[yum]",
           "recipe[ntp]",
           "recipe[timezone]",
           "recipe[chef-client]",
           "recipe[zsh]",
           "recipe[users::sysadmins]",
           "recipe[users::qa]",
           "recipe[sudo]",
           "recipe[emacs]",
           "recipe[vim]",
           "recipe[git]",
           "recipe[build-essential]",
           "recipe[cron]",
           "recipe[perl]",
           "recipe[python]",
           "recipe[screen]",
           "recipe[nscd]",
           "recipe[openssh]",
           "recipe[motd-tail]",
           "recipe[operations]"
          ]
run_list(all_env)

env_run_lists(
              "_default" => all_env,
              "qa2" => all_env,
              "dev" => all_env,
              "prod" => all_env + ["role[monitored]"],
              "ec2-prod" => all_env + ["recipe[users::data-team]"],
              "ec2" => all_env
              )

default_attributes ({
      "ntp" => {
        "servers" => ["ntp101.ihrdev.com", "ntp102.ihrdev.com"],
      }
})
