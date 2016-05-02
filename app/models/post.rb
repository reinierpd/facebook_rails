class Post < ActiveRecord::Base
  belongs_to :user
  has_one :image , :class_name=>'Picture', :as=>:imageable
  acts_as_likeable
end
