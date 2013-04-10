class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  attr_accessible :email, :password, :password_confirm, :username

  # Following & Followers
  has_many :relationships, :foreign_key => "follower_id", :class_name => "Minitweet::Relationship", :dependent => :destroy
  has_many :followed_users, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Minitweet::Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_many :posts, :class_name => "Minitweet::Post", :dependent => :destroy

  validates_confirmation_of :password
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 5..25 }
  validates :email, :presence => true, :uniqueness => true, :length => { :in => 10..30 }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }


  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(:followed_id => other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Minitweet::Post.from_users_followed_by(self)
  end

end
