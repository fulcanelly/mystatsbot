
class InlineKeyboardHelper 

    def initialize(user)
        @user = user
    end

    def method_missing(name, **args)
        @user.inline_keyboards.create(dump: "name()")
    end

end

#TODO (may be BaseState limited)

class InlineCbHandler < BaseState


    def select_activity(data)
    end

    def handle(cbdata)
        
    end
end