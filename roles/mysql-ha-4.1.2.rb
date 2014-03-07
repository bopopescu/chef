name "mysql-ha"
description "MySQL with Master-Master Replication"
all_env = [
           "recipe[mysql@4.1.2]",
           "recipe[mysql::server@4.1.2]",
           "recipe[mysql::ha@4.1.2]"
          ]
run_list(all_env)

env_run_lists(
              "_default" => all_env,
              "qa2" => all_env,
              "dev" => all_env,
              "prod" => all_env,
              "ec2-prod" => all_env + ["recipe[mysql::server_ec2]"],
              "ec2" => all_env
              )
