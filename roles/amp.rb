name "amp"
description "Amp - API"
run_list(
         "role[auto-bonded]",
         "recipe[amp]"

)
