class Picture < ActiveRecord::Base
  belongs_to :imageable , :polymorphic=> true
  has_attached_file :content, :styles => { :medium => "640x480>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :content, :content_type => /\Aimage\/.*\Z/
end
