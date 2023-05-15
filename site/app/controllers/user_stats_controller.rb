class UserStatsController < ApplicationController
  before_action :set_user_stat, only: %i[ show edit update destroy ]

  # GET /user_stats or /user_stats.json
  def index
    @user_stats = UserStat.all
  end

  # GET /user_stats/1 or /user_stats/1.json
  def show
  end

  # GET /user_stats/new
  def new
    @user_stat = UserStat.new
  end

  # GET /user_stats/1/edit
  def edit
  end

  # POST /user_stats or /user_stats.json
  def create
    @user_stat = UserStat.new(user_stat_params)

    respond_to do |format|
      if @user_stat.save
        format.html { redirect_to user_stat_url(@user_stat), notice: "User stat was successfully created." }
        format.json { render :show, status: :created, location: @user_stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stats/1 or /user_stats/1.json
  def update
    respond_to do |format|
      if @user_stat.update(user_stat_params)
        format.html { redirect_to user_stat_url(@user_stat), notice: "User stat was successfully updated." }
        format.json { render :show, status: :ok, location: @user_stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stats/1 or /user_stats/1.json
  def destroy
    @user_stat.destroy

    respond_to do |format|
      format.html { redirect_to user_stats_url, notice: "User stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stat
      @user_stat = UserStat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_stat_params
      params.require(:user_stat).permit(:user_id)
    end
end
