class Driver < ActiveRecord::Base
 self.per_page  =  20
 has_many :routes
 belongs_to :category
end
