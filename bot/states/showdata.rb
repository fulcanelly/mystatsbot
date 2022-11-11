

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