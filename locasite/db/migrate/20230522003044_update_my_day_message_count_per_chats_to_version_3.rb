class UpdateMyDayMessageCountPerChatsToVersion3 < ActiveRecord::Migration[7.0]
  def change
  
    update_view :my_day_message_count_per_chats, version: 3, revert_to_version: 2
  end
end
