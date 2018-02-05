class GroupAttachmentsController < ApplicationController
  def download
    attachment = GroupAttachment.find(params[:group_attachment_id]).attachment
    data = open(attachment.url)
    send_data(
      data.read,
      filename: attachment.metadata["filename"],
      type: attachment.metadata["mime_type"]
    )
  end
end
