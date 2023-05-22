class CreateMyDayMessageCountPerChats < ActiveRecord::Migration[7.0]
  def change
    create_view :my_day_message_count_per_chats
  end
end
