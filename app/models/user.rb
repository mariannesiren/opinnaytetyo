class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true

  def name
    [first_name, last_name].join(" ")
  end
end
