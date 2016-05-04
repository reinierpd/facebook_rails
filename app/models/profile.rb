class Profile < ActiveRecord::Base

  has_many :images, :class_name=>'Picture', :as=>:imageable
  belongs_to :profile_img, :class_name => 'Picture', :foreign_key => 'profile_img_id'
  belongs_to :poster_img, :class_name => 'Picture', :foreign_key => 'poster_img_id'
  belongs_to :user
  acts_as_liker
  delegate :full_name, to: :user
  def age
    now = Date.today
    res = self.birthday != nil ? (now.year - self.birthday.year - (now.strftime('%m%d') < self.birthday.strftime('%m%d') ? 1 : 0)):'unknown'
  end
  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end

end
