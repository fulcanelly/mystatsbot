

class StatePussy < BaseState 
    def run 
        say "hi from state pussy"
        switch_state ShowDataState.new(MainMenuState.new)
    end

end

class ShowDataState < BaseState

    include CommonInline
    
    def initialize(back)
        @back = back
    end

    def run 
        text, stuff = get_stories_page()
        say(text, reply_markup: stuff)
        switch_state @back
    end

end