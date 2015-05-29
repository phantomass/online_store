class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :password, length: { minimum: 6 }
  validates :password, length: { maximum: 20 }
  has_secure_password
end