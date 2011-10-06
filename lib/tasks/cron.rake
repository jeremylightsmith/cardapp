task :cron do
  GroupPatternsController.new.cache
end
  