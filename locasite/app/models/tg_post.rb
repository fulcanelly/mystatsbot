class TgPost < ApplicationRecord

  after_find do
    next if self.respond_to? :tg_post_id
    Chat.find_or_create_by(id: chat_id)
  end

  after_save do
    Chat.find_by(id: chat_id)&.touch
  end

  belongs_to :day
  belongs_to :chat
end
