class AddChatAndMessageIdsToTgPosts < ActiveRecord::Migration[7.0]
  def up
    add_column :tg_posts, :chat_id, :string
    add_column :tg_posts, :message_id, :string

    TgPost.find_each do |tg_post|
      chat_id, message_id = tg_post.tg_post_id.split(':')
      tg_post.update_columns(chat_id: chat_id, message_id: message_id)
    end

    remove_column :tg_posts, :tg_post_id
  end

  def down
    add_column :tg_posts, :tg_post_id, :string

    TgPost.find_each do |tg_post|
      tg_post.update_columns(tg_post_id: "#{tg_post.chat_id}:#{tg_post.message_id}")
    end

    remove_column :tg_posts, :chat_id
    remove_column :tg_posts, :message_id
  end
end
