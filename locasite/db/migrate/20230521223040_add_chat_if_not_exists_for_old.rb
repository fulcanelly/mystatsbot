class AddChatIfNotExistsForOld < ActiveRecord::Migration[7.0]
  def change
    TgPost.find_each do
    end
  end
end
