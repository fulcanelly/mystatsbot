
class InlineKeyboardHelper 

    def initialize(user)
        @user = user
    end

    def method_missing(name, *args)
        @user.inline_keyboards.create(dump: "#{name}(#{args.join(",")})").id
    end

end

module CommonInline  

    
    PAGE_SIZE = 3

    def get_story_page

    end


    def get_stories_page(page_number = 0)
        ikbhelper = InlineKeyboardHelper.new(myself)
        kb = InlineKeyboardExtra.create 
        
        myself.stories()
            .order(created_at: :desc)
            .offset(page_number * PAGE_SIZE)
            .limit(PAGE_SIZE).lazy 
            .map do |story|
                ibutton("[#{story.created_at}] #{story.activity.name}\n", "loli")
            end
            .each do 
                kb.add_row(_1)
            end
        
        tools_row = []

        kb.add_row(
            ibutton("<<", ikbhelper.get_stories_page(page_number - 1)),
            ibutton("{ #{page_number + 1} }", "1"),
            ibutton(" >>", ikbhelper.get_stories_page(page_number + 1)),
        )
            #kb.add_row
        
        return "Stories page #{page_number}", kb.obtain
        
    end


end

