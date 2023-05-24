class Api::V1::MessageLoadsController < ActionController::API
  def chats_to_load_from
    last_update_time = params[:last_update_time] || Time.now - 1.day

    to_exclude = TgPost.where('tg_posts.updated_at > ?', last_update_time)

    chats_to_exclude = TgPost.where('tg_posts.updated_at > ?', last_update_time)
      .select(:chat_id)
      .distinct

    result = TgPost.joins(:day)
      .where.not(id: chats_to_exclude)
      .group(:chat_id)
      .order(count_all: :asc)
      .limit(10)
      .count
      .map(&:first)

    render json: result
  end
end
