begin
    unless tagged?("talk-encoder")

    node[:encoders][:talk][:encoder][:startup_scripts].each do |script,template|
        template script do
            source template
            owner "root"
            mode "0755"
            variables({
               :num_converters => node[:talk_converters][:num_processors]
            })
        end
        service script.gsub(/\/etc\/init.d\//, "") do
            action [:enable, :start]
        end
    end

    node[:encoders][:talk][:encoder][:monitor_scripts].each do |script,template|
        template script do
            source template
            owner "root"
            mode "0755"
            variables({
               :num_converters => node[:talk_converters][:num_processors]
            })
        end
        cron script do
            command script " > /dev/null 2>&1"
            minute  "*/2"
            hour    "*"
            day     "*"
            month   "*"
            weekday "*"
        end
    end

   tag("talk-encoder")
   end
rescue
    untag("talk-encoder")
end
