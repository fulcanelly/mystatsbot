# frozen_string_literal: true

class ShowDataOnSite < BaseState
  def run
    say 'todo'
    switch_state MainMenuState.new
  end
end
