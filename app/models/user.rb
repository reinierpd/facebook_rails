class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :name, presence: true
  has_many :posts
  has_one :profile_img, :as=>:imageable
  has_one :poster_img, :as=>:imageable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
