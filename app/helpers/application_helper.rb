module ApplicationHelper
  def attachment_link_for(attachment)
    link_to (attachment.attachment.metadata["filename"]), attachment.attachment_url
  end
end
