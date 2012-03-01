class Category < ActiveRecord::Base
 self.per_page = 20
 has_many :drivers
end
