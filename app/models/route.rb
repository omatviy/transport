class Route < ActiveRecord::Base
  self.per_page = 20
  belongs_to :driver
end
