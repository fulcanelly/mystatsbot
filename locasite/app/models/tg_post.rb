class TgPost < ApplicationRecord

  after_find do
    Chat.find_or_create_by(id: self.chat_id)
  end

  belongs_to :day
  belongs_to :chat
end
