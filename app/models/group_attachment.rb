class GroupAttachment < ApplicationRecord
  include FileUploader::Attachment.new(:attachment)
  belongs_to :group
end
