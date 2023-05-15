require "test_helper"

class UserStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_stat = user_stats(:one)
  end

  test "should get index" do
    get user_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_user_stat_url
    assert_response :success
  end

  test "should create user_stat" do
    assert_difference("UserStat.count") do
      post user_stats_url, params: { user_stat: { user_id: @user_stat.user_id } }
    end

    assert_redirected_to user_stat_url(UserStat.last)
  end

  test "should show user_stat" do
    get user_stat_url(@user_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_stat_url(@user_stat)
    assert_response :success
  end

  test "should update user_stat" do
    patch user_stat_url(@user_stat), params: { user_stat: { user_id: @user_stat.user_id } }
    assert_redirected_to user_stat_url(@user_stat)
  end

  test "should destroy user_stat" do
    assert_difference("UserStat.count", -1) do
      delete user_stat_url(@user_stat)
    end

    assert_redirected_to user_stats_url
  end
end
