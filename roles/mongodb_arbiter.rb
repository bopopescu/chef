name "mongodb_arbiter"
description "mongodb_arbiter"
all_env = [
           "recipe[mongodb]",
	   "recipe[mongodb::arbiter]",
           "recipe[mongodb::ulimits]",
	  ]
run_list(all_env)
env_run_lists(
              "_default" => all_env,
              "qa2" => all_env,
              "prod" => all_env,
              "ec2" => all_env
              )
default_attributes({
                     "mongodb" => {
		     }
                   })
override_attributes({
                    })
