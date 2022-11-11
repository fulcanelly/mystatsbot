

class ShowDataState < BaseState

    include CommonInline

    def initialize(back)
        @back = back
    end

    def run 
        page = get_stories_page()

        case get_stories_page()
        in {page: {text:, kb:}}
            say(text, reply_markup: kb)
        end
            
        switch_state @back
    end

end