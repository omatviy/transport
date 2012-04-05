namespace :db do
 desc "Populating db"
 #require "populate"
 #Route.delete_all
 #Driver.delete_all
 
 task :populate => :environment do
  for category in ("a".."e").to_a do
   Category.create(:name=>category)  
  end

  category_ids = Category.all.map{|c| c.id}
  
  Driver.populate(50) do |driver|
   driver.name = "#{Faker::Name.last_name} #{Faker::Name.first_name}"
   driver.tel = Faker::PhoneNumber.phone_number
   driver.category_id = category_ids
   puts "Driver: name->#{driver.name} tel->#{driver.tel} category->#{driver.category_id}"
   Route.populate(1..2) do |route|
    route.number = 1..30
    route.name = Populator.words(2)
    route.driver_id = driver.id
    puts "Route: number->#{route.number} name->#{route.name}"
   end
  end 
 end
end
