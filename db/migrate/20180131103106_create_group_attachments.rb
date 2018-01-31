class CreateGroupAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :group_attachments do |t|
      t.jsonb :attachment_data
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
