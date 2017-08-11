class User < ActiveRecord::Base
  has_many :reviews

  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates_presence_of :full_name
  validates :password, presence: true, on: :create#, length: { minimum: 2 }
end
