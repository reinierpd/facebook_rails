class Profile < ActiveRecord::Base

  has_one :profile_img, :class_name=>'Picture', :as=>:imageable
  has_one :poster_img, :class_name=>'Picture', :as=>:imageable
  belongs_to :user
  acts_as_liker
end
