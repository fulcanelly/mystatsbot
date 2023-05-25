class Api::V1::TgPostsController < ActionController::API

  def create
    puts 'AAA' * 1000
    date = Date.parse(params[:serialized_date])
    day = Day.find_or_create_by(date: date)

    @tg_post = TgPost.new(tg_post_params)
    @tg_post.day = day

    if @tg_post.save
      render json: @tg_post, status: :created
    else
      render json: @tg_post.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    render json: e.message, status: :unprocessable_entity
    Chat.find_by(id: tg_post_params[:chat_id])&.touch
  rescue ActiveRecord::StatementInvalid => e
    puts e.message
    puts "RETRYING" * 100
    # TODO limit amount of retryies ?
    sleep 0.1
    retry
  end

  # TODO, where send_by_id: my and not my
  # TgPost.joins(:day)
  #   .where(chat_id: chat_id) # TODO: .where(days: { date: start_date..end_date })
  #   .group('days.date')
  #   .count.to_a

  def posts_per_day
    chat_id = params[:chat_id]

    posts_count_per_day =
      if chat_id

        send_by_me_counts = TgPost.joins(:day)
          .where(chat_id: chat_id)
          .where(send_by_id: nil)
          .group('days.date')
          .count
          .map { next _1, -_2 }
          .to_h

        send_by_others_counts = TgPost.joins(:day)
          .where(chat_id: chat_id)
          .where.not(send_by_id: nil)
          .group('days.date')
          .count

        send_by_me_counts.merge(send_by_others_counts) { |_, a, b| a + b }
          .to_a

      else
        send_by_me_counts = TgPost.joins(:day)
          .where(send_by_id: nil)
          .group('days.date')
          .count
          .map { next _1, -_2 }
          .to_h

        send_by_others_counts = TgPost.joins(:day)
          .where.not(send_by_id: nil)
          .group('days.date')
          .count

        send_by_me_counts.merge(send_by_others_counts) { |_, a, b| a + b }
          .to_a
      end

    render json: posts_count_per_day
  end

  def chat_stats_of_day
    date = params[:day]

    render json: MyDayMessageCountPerChat.where(date: date)
  end

  private

  def tg_post_params
    params.require(:tg_post).permit(:chat_id, :message_id, :send_by_id)
  end

  # TODOapp/controllers/api/v1/tg_posts_controller.rb
  # def top_chats
  #   TgPost.joins(:chat).group(:first_name, :chat_id).order(count_all: :desc).limit(10).count
  # end

end
