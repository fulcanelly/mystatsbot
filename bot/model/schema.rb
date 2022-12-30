require 'colored'

class User < ActiveRecord::Base

    has_many :activities
    has_many :stories

    has_one :state
    has_many :inline_keyboards

    accepts_nested_attributes_for :activities, :stories, :state

end

class State < ActiveRecord::Base 

    belongs_to :user

    accepts_nested_attributes_for :user

end

class Activity < ActiveRecord::Base 

    belongs_to :user
    has_many :stories

    accepts_nested_attributes_for :user

end

class Story < ActiveRecord::Base

    def get_next_story()
        self.user()
            .stories()
            .order(id: :asc)
            .where("id > ?", id)
            .first()
    end

    def time_took 
        next_story = get_next_story()

        if next_story then 
            next_story.created_at().to_i - self.created_at().to_i
        else 
            Time.now.to_i - self.created_at().to_i
        end
    end

    belongs_to :user
    belongs_to :activity

    accepts_nested_attributes_for :user, :activity

end

class InlineKeyboard < ActiveRecord::Base

    belongs_to :user
    
end
