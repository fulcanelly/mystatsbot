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

    belongs_to :user
    belongs_to :activity

    accepts_nested_attributes_for :user, :activity

end

class InlineKeyboard < ActiveRecord::Base

    belongs_to :user
    
end
