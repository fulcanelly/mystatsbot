class Api::V1::MessageLoadsController < ActionController::API
  def chats_to_load_from
    last_update_time = params[:last_update_time] || Time.now - 1.day


    chats_to_exclude_by_chats = TgPost.where('updated_at > ?', last_update_time)
      .select(:chat_id)
      .distinct

    chats_to_exclude = Chat.where('updated_at > ?', last_update_time)
      .select(:id)

    result = TgPost.joins(:day)
      .where.not(id: chats_to_exclude_by_chats)
      .where.not(chat_id: chats_to_exclude)
      .group(:chat_id)
      .order(count_all: :asc)
      .limit(10)
      .count
      .map(&:first)

    render json: result
  end
end
