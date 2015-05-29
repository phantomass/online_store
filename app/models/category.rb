class Category < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 20 }
  has_many :products
end
