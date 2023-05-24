class ChatStatsController < ApplicationController
  #layout "chat_stats"
  def index
    {}
  end

  def show
    @chat_stats_props = Chat.find(params[:id]).as_json
    render 'index'
  end
end
