class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :messages
  has_many :group_users
  has_many :groups, through: :group_users

  def self.search(keyword, userIds)
    User.where(['name LIKE ?', "%#{keyword}%"]).where.not(id: userIds).limit(10)
  end
end
