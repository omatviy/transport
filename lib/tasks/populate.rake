namespace :db do
 desc "Populating db"
 #Route.delete_all
 #Driver.delete_all
 
 task :populate => :environment do
  Driver.populate(50) do |driver|
   driver.name = "#{Faker::Name.last_name} #{Faker::Name.first_name}"
   driver.tel = Faker::PhoneNumber.phone_number
   driver.category = ["a", "b", "c", "d"]
   puts "Driver: name->#{driver.name} tel->#{driver.tel} category->#{driver.category}"
   Route.populate(1..2) do |route|
    route.number = 1..30
    route.name = Populator.words(2)
    route.driver_id = driver.id
    puts "Route: number->#{route.number} name->#{route.name}"
   end
  end 
 end
end
