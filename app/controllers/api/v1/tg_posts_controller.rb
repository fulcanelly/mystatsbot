class Api::V1::TgPostsController < ApplicationController
  before_action :set_tg_post, only: [:show, :update, :destroy]

  def show
    render json: @tg_post
  end

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
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    posts_count_per_day = TgPost.where(created_at: start_date..end_date)
      .group('DATE(created_at)')
      .count

    render json: posts_count_per_day
  end

  private

  def tg_post_params
    params.require(:tg_post).permit(:tg_post_id, :day_id)
  end
end
