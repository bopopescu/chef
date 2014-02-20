name "jobserver"
description "Job Server: Cron, ETL, Etc."
all_env = [
           "recipe[jobserver]",
           "recipe[users::jobserver-sudo]",
           "recipe[splunk::forwarder]",
           "role[etljob_server]",
           "role[mongosd]",
	   "role[sendmail-smart-host]"

          ]
run_list(all_env)

env_run_lists(
              "_default" => all_env,
              "qa2" => all_env,
              "dev" => all_env,
              "prod" => all_env + ["recipe[bondage::dns]"],
              "ec2-prod" => all_env,
              "ec2" => all_env
              )

override_attributes({
        "splunk" => {
            "forwarder_config_folder" => "prod",
            "forwarder_role" =>  "jobserver"
        },
        "java" => {
            "install_flavor" => "oracle",
            "jdk_version" => "7"
        }
})
