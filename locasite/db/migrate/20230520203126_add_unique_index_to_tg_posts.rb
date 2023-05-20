class AddUniqueIndexToTgPosts < ActiveRecord::Migration[7.0]
  def change
    add_index :tg_posts, [:chat_id, :message_id], unique: true
  end
end
