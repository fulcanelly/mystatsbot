require 'colored'

class User < ActiveRecord::Base

    has_many :activities
    has_many :stories

    has_one :state
    has_many :inline_keyboards
    has_many :user_props

    accepts_nested_attributes_for :activities, :stories, :state
end


class UserProp < ActiveRecord::Base

    belongs_to :user

end

class State < ActiveRecord::Base

    belongs_to :user

    accepts_nested_attributes_for :user

end

class Activity < ActiveRecord::Base

    belongs_to :user
    has_many :stories

    accepts_nested_attributes_for :user

    #WARN use view for that
    def time_took_at?(day)

    end

end

class Story < ActiveRecord::Base

    #TODO make it run on timer
    def self.destroy_rarely_used()
        old_condition = Time.now() - ActiveSupport::Duration.days(5).in_seconds

        self.all()
            .where("updated_at < ?", old_condition)
            .destroy_all()
    end

    after_find do |it|
        if it.updated_at.to_date != Time.now.to_date then
            it.updated_at = Time.now
            it.save
        end
    end

    def get_next_story()
        self.user()
            .stories()
            .order(id: :asc)
            .where("id > ?", id)
            .first()
    end

    #WARN use view for that
    def was_done_at?(day)
        started_at = self.created_at.to_date
        ended_at = (self.created_at + self.time_took).to_date

        started_at <= day && ended_at >= day
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
