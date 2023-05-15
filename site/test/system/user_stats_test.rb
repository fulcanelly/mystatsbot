require "application_system_test_case"

class UserStatsTest < ApplicationSystemTestCase
  setup do
    @user_stat = user_stats(:one)
  end

  test "visiting the index" do
    visit user_stats_url
    assert_selector "h1", text: "User stats"
  end

  test "should create user stat" do
    visit user_stats_url
    click_on "New user stat"

    fill_in "User", with: @user_stat.user_id
    click_on "Create User stat"

    assert_text "User stat was successfully created"
    click_on "Back"
  end

  test "should update User stat" do
    visit user_stat_url(@user_stat)
    click_on "Edit this user stat", match: :first

    fill_in "User", with: @user_stat.user_id
    click_on "Update User stat"

    assert_text "User stat was successfully updated"
    click_on "Back"
  end

  test "should destroy User stat" do
    visit user_stat_url(@user_stat)
    click_on "Destroy this user stat", match: :first

    assert_text "User stat was successfully destroyed"
  end
end
