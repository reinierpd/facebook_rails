class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :name, presence: true
  has_many :posts
  has_one :profile , dependent: :destroy
  has_many :friendships, dependent: :destroy, foreign_key: :requester_id
  has_many :friended_users, through: :friendships, source: :requested
  has_many :reverse_friendships, class_name: "Friendship",
           dependent: :destroy,
           foreign_key: :requested_id
  has_many :frienders, through: :reverse_friendships, source: :requester
  # validations
  validates :first_name, presence:true
  validates :last_name, presence:true
  validates :gender, presence:true
  validates :email, presence:true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :build_default_profile
  acts_as_liker


  # send friend request to another user.

  # Instance methods
  def send_friend_request_to(other_user)
    unless self == other_user || friends_with?(other_user) ||
        has_friend_request_from?(other_user) ||
        other_user.has_friend_request_from?(self)
      self.friendships.create(requested_id: other_user.id, accepted: false)
     end
  end

  def accept_friend_request_from(other_user)
    friend_request = get_friend_request(other_user, self)
    friend_request && friend_request.update_attributes(accepted: true)
  end

  def reject_friend_request_from(other_user)
    friend_request = get_friend_request(other_user, self)
    friend_request && friend_request.destroy
  end

  def unfriend(other_user)
    friendship = get_friendship(self, other_user)
    friendship && friendship.destroy
  end

  def get_friend_request_from(other_user)
    get_friend_request(other_user, self)
  end
  def has_friend_request_from?(other_user)
    !get_friend_request(other_user, self).nil?
  end

  def friends_with?(other_user)
    !get_friendship(self, other_user).nil?
  end

  def friends
    requester_friends_ids = "SELECT requester_id FROM friendships
                            WHERE requested_id = :user_id AND accepted = :accepted"
    requested_friends_ids = "SELECT requested_id FROM friendships
                            WHERE requester_id = :user_id AND accepted = :accepted"

    User.where("id IN (#{requester_friends_ids}) OR
                id IN (#{requested_friends_ids})", user_id: self.id, accepted:true)

  end

  def requests_from
    requesters_ids = "SELECT requester_id FROM friendships
                     WHERE requested_id = :user_id AND accepted = :accepted"

    User.where("id IN (#{requesters_ids})", user_id: self.id, accepted:false)
  end

  def no_friendship
    requesters_ids = "SELECT requester_id FROM friendships
                     WHERE requested_id = :user_id"
    requesteds_ids = "SELECT requested_id FROM friendships
                     WHERE requester_id = :user_id"

    User.where("id NOT IN (#{requesters_ids}) AND NOT id = :user_id AND
                id NOT IN (#{requesteds_ids})", user_id: self.id)
  end

  def post_feed
    requester_friends_ids      = "SELECT requester_id FROM friendships
                                 WHERE requested_id = :user_id AND accepted = :accepted"
    requested_friends_ids      = "SELECT requested_id FROM friendships
                                 WHERE requester_id = :user_id AND accepted = :accepted"
    friends_created_posts_id  = "SELECT id FROM posts
                                 WHERE user_id IN (#{requester_friends_ids}) OR
                                       user_id IN (#{requested_friends_ids}) OR
                                       user_id = :user_id"

    Post.where("id IN (#{friends_created_posts_id})", user_id: self.id, accepted:true)
        .order('created_at DESC')
  end

  private

  # Get the Friendship AR that represents the friendship between
  # two users. Return nil if the users are not friends
  def get_friendship(user1, user2)
    user1.friendships.find_by(requester_id: user2.id, accepted: true) ||
        user2.friendships.find_by(requested_id: user1.id, accepted: true)
  end

  # Get the Friendship AR that represents a friend request from
  # one user to another. Return nil if no such request exists
  def get_friend_request(from_user, to_user)
    from_user.friendships.find_by(requested_id: to_user.id, accepted: false)
  end
  def build_default_profile
    self.build_profile()
  end
end
