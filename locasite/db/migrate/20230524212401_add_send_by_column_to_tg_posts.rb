class AddSendByColumnToTgPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :tg_posts, :send_by_id, :integer
  end
end
