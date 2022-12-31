

class MainMenuState < BaseState
    
    def run 
        suggest_it("What to do ?")
            .tap do 
                _1.option("Start activity") do 
                    switch_state EnterActivityState.new(MainMenuState.new)
                end unless self.myself.activities.empty?

            end
            .option("Settings") do
                switch_state SettingState.new(MainMenuState.new)
            end
            .option("Show data") do 
                switch_state ShowDataState.new(MainMenuState.new)
            end
            .exec

        switch_state MainMenuState.new
    end
    
end

class EnterActivityState < BaseState
    
    def initialize(back)
        @back = back
    end

    def run         
        loop do 
            #select activity
            act = suggest_it("Select activity to start")
                .tap do |sg|
                    myself.activities.each do |act| 
                        sg.option(act.name) do act end
                    end
                end
                .option("Back") do 
                    switch_state(@back)
                end
                .exec
                
            unless suggest_it("Are you sure ?")
                .option("Yes") do  true end
                .option("No (Cancel)") do end
                .exec then 
                next
            end


            #save start time 
            myself.stories.create(
                status: "start",
                activity: act
            )

            say "Activity /#{act.name}/ started"
        end

    end

end

class SettingState < BaseState
    include CommonInline

    def initialize(back)
        @back = back
    end

    def activity_settings()
        run = true 
        while run 

            actlist = myself.activities
                .map(&:name).join("\n")

            say_ikb(get_activities_settings()) 

            suggest_it("Your activites")
                .option("Add new activity") do
                    say "Enter activity name"
                    text = expect_text()

                    myself.activities << Activity.new(name: text)
                    myself.save
                end
                .option("Back") do 
                    run = false 
                end
                .exec
        end

    end

    def time_settings 
        case get_time_settings()
        in {page: {text:, kb:}}
            say(text, reply_markup: kb)
        end
    end

    def run 
        suggest_it("Settings")
            .option("Activity settings") do 
                activity_settings()
            end
            .option("Time sttings") do 
                time_settings()
            end
            .option("Back") do 
                switch_state(@back)
            end
            .exec()
        
        switch_state __clean_state(self)
    end

end

class RenameActivity < BaseState

    def initialize(id)
        @id = id  
    end

    def run 
        activity = Activity.find_by(id: @id)
        say "Enter new name for activity #{activity.name}"
        new_name = expect_text 

        activity.tap do 
            activity.name = new_name 
            activity.save
        end


        switch_state SettingState.new(MainMenuState.new)
    end

end

class ChangeActivityOfStoryState < BaseState 
    
    attr_accessor :story_id

    def initialize(story_id) 
        @story_id = story_id
    end

    def run 
        update_activity = suggest_it("Select activity to change to")
            .tap do |sg|
                myself.activities.each do |activity| 
                    sg.option(activity.name) do activity end
                end
            end
            .option("Cancel") do 
                switch_state MainMenuState.new 
            end
            .exec

        Story.find_by(id: story_id)
            .tap do 
                _1.activity = update_activity
            end
            .save 

        switch_state MainMenuState.new 
    end

end
