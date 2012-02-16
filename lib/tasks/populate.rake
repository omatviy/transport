namespace :db do
 desc "Populating db"
 task :populate => :environment do
  Route.populate(30) do |route|
   route.number = 1..30
   route.name = Populator.words(2)
  end
 end
end
