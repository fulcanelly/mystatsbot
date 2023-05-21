class AddIsDeletedToChat < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :is_deleted, :boolean, default: false
  end
end
