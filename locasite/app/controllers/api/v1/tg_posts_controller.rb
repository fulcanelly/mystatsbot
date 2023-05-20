class Api::V1::TgPostsController < ActionController::API

  def create
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
  end

  def posts_per_day
    # TODO
    # start_date = Date.parse(params[:start_date])
    # end_date = Date.parse(params[:end_date]) + 1

    # if (end_date - start_date).to_i > 365
    #   render json: { error: 'Date range exceeds one year' }, status: :unprocessable_entity
    #   return
    # end

    posts_count_per_day = TgPost.joins(:day)#.where(days: { date: start_date..end_date })
      .group('days.date')
      .count.to_a

    render json: posts_count_per_day
  end

  private

  def tg_post_params
    params.require(:tg_post).permit(:tg_post_id, :day_id)
  end
end
