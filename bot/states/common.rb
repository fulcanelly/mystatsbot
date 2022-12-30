
class InlineKeyboardHelper 

    def initialize(user)
        @user = user
    end

    def method_missing(name, *args)
        @user.inline_keyboards.create(dump: "#{name}(#{args.join(",")})").id
    end

end

module CommonInline  

    
    PAGE_SIZE = 6

    def get_story_page

    end

    # def get_time_settings(time = Time.now.to_f)
    #     time = Time.new time
    #     ikbhelper = InlineKeyboardHelper.new(myself)

    #     kb = InlineKeyboardExtra.create 

    #     kb.add_row(
    #         ibutton("Hours", "g"),
    #         ibutton("Minutes", "g"),
    #     )

    #     kb.add_row(
    #         ibutton("🔼", ikbhelper.get_time_settings),
    #         ibutton("🔼", "g"),   
    #     )

       
    #     kb.add_row(
    #         ibutton(time.hour.to_s, "g"),
    #         ibutton(time.min.to_s, "g")
    #     )

    #     kb.add_row(
    #         ibutton("🔽", "ds"),
    #         ibutton("🔽", "sd")
    #     )
        
    #     kb.add_row(
    #         ibutton(" ", "nop")
    #     )
    #     kb.add_row(
    #         ibutton("Save", "1"),
    #         ibutton("Cancel", "+")
    #     )
    
    #     return {
    #         page: {
    #             text: "Time settings #{time}", 
    #             kb: kb.obtain
    #         }
    #     }
    # end

    def select_act_to_start(page_number = 0)
        kb = InlineKeyboardExtra.create 

    end

    def say_ikb(data) 
        case data
        in {page: {text:, kb:}}
            say(text, reply_markup: kb)
        end
    end

    def delete_activity(id)
        activity = myself.activities.find_by(id:)
        if activity.stories.empty? then 
            activity.destroy
            return get_activities_settings()
        else     
            say("Not implemented for activities that have stories ")
        end

    end


    def rename_activity(id)
        switch_state RenameActivity.new(id)
    end

    def get_activity_settins(id)
        ikbhelper = InlineKeyboardHelper.new(myself)
        kb = InlineKeyboardExtra.create 

        kb.add_row(
            ibutton("Delete 🗑", ikbhelper.delete_activity(id)),
            ibutton("Rename ✏️", ikbhelper.rename_activity(id)),
        )
        kb.add_row(
            ibutton("Back ◀️", ikbhelper.get_activities_settings())
        )

        return {
            page: {
                text: "Activity #{myself.activities.find_by(id:).try do _1.name end}", 
                kb: kb.obtain
            }
        }
    end


    def get_activities_settings() 
        ikbhelper = InlineKeyboardHelper.new(myself)
        kb = InlineKeyboardExtra.create 

        myself.activities()
            .each do |act|
                btn = ibutton(
                    "#{act.name} (Stories #{act.stories.count})",
                    ikbhelper.get_activity_settins(act.id)
                )

                kb.add_row(btn)
            end

        return {
            page: {
                text: "Your activities", 
                kb: kb.obtain
            }
        }

    end


    def nop()
    end

    def get_stories_page(page_number = 0)
        if page_number < 0 then 
            return 
        end

        ikbhelper = InlineKeyboardHelper.new(myself)
        kb = InlineKeyboardExtra.create 

        myself.stories()
            .order(created_at: :desc)
            .offset(page_number * PAGE_SIZE)
            .limit(PAGE_SIZE).lazy 
            .map do |story|
                __make_story_button(story, ikbhelper)
            end
            .each do 
                kb.add_row(_1)
            end
        
        tools_row = []

        page_number_to_show = page_number + 1

        kb.add_row( 
            ibutton("<<", ikbhelper.get_stories_page(page_number - 1)),
            ibutton("{ #{page_number_to_show} }", ikbhelper.nop()),
            ibutton(" >>", ikbhelper.get_stories_page(page_number + 1)),
        )
            #kb.add_row
        
        return {
            page: {
                text: "Stories page #{page_number_to_show}", 
                kb: kb.obtain
            }
        }
        
    end

    def __make_story_button(story, ikbhelper) 
        readable_time_string = FormatHelper
            .format_time(story.time_took).then do 
                if _1.empty? then "" else _1 + " took" end
            end
        ibutton("[#{story.created_at}] #{story.activity.name}, #{readable_time_string}", ikbhelper.nop)
    end

end

