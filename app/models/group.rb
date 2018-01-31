class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :attachments, class_name: "GroupAttachment", inverse_of: :group, dependent: :destroy
  validates :name, presence: true
end
