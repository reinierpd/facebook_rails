class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :name, presence: true
  has_many :posts
  has_one :profile , dependent: :destroy

  # validations
  validates :first_name, presence:true
  validates :last_name, presence:true
  validates :gender, presence:true
  validates :email, presence:true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :build_default_profile
  acts_as_liker

  private

  def build_default_profile
    self.build_profile()
  end
end
