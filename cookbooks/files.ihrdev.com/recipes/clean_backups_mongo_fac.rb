cron_d "clean_backups_mongo_fac" do
  command "/usr/bin/find /data/exports/files.ihrdev.com/mongo_fac_bak -type f -printf '\\%T@ \\%p\\n' | sort -n | cut -d' ' -f2- | head -n -1 | xargs rm"
  minute  "25"
  hour    "6"
  month   "*"
  weekday "*"
  user    "root"
end
