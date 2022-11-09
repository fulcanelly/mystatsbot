

class StatePussy < BaseState 
    def run 
        say "hi from state pussy"
        switch_state ShowDataState.new(MainMenuState.new)
    end

end

class ShowDataState < BaseState

    def initialize(back)
        @back = back
    end

    def run 
        stories = myself.stories()
            .order(created_at: :desc)
            .limit(10).lazy
            .map do |story| 
                next {
                    text: "[#{story.created_at}] #{story.activity.name}\n",
                    callback_data: "todo"
                } 
            end
            .map do
                [_1] 
            end.force


        say("Data", reply_markup: {
            inline_keyboard: stories
        })

        switch_state @back
    end

end