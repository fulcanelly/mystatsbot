
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

    def none() 
        return {
            page: {
                text: 'meow',
                kb: {
                    inline_keyboard: []
                }
            }
        }
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
                if _1.empty? then "" else "took " + _1 end
            end

        result_string = [
            if story.get_next_story then nil else "🟢" end,
            story.activity.name,
            readable_time_string,
            FormatHelper.format_date(story.created_at),
        ].then do |entries| 
            entries.filter do _1 end
                .join(" | ")
        end

        ibutton(result_string, ikbhelper.show_story_detailed(story.id))
    end

    def todo 
        return {
            answer: "In development"
        }
    end

    # @param story_id [Integer]
    # @return [Hash]
    def show_story_detailed(story_id)
        story = Story.find_by(id: story_id)

        ikbhelper = InlineKeyboardHelper.new(myself)
        kb = InlineKeyboardExtra.create 

        kb.add_row(
            ibutton("Show more of #{story.activity.name}", ikbhelper.todo())
        )

        kb.add_row(
            ibutton("Delete 🗑", ikbhelper.todo()), 
            ibutton("Edit ✏️", ikbhelper.todo())
        )

        kb.add_row(
            ibutton("Back", ikbhelper.get_stories_page())
        )
        
        status_text = if story.get_next_story then  
                "Done ☑️"
            else
                "Ongoing 🟢"
            end

        return {
            page: {
                text: "
                #{story.activity.name} story detailed 
                
                Started: #{FormatHelper.format_date(story.created_at)}
                Time took: #{FormatHelper.format_time(story.time_took)} ⏳
                Status: #{status_text}
                ".multitrim, 
                kb: kb.obtain()
            }
        }
    end

end
