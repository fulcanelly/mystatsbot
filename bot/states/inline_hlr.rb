
class InlineKeyboardHelper 

    def initialize(user)
        @user = user
    end

    def method_missing(name, **args)
        @user.inline_keyboards.create(dump: "name()")
    end

end

class AnswerCallbackQueryAction < BaseAction
    attr_accessor :data, :callback_query_id
    
    def initialize(callback_query_id, **data)
        @callback_query_id = callback_query_id
        @data = data
    end
    
    def exec(ctx)
        ctx.extra.bot.answer_callback_query({callback_query_id:, **data})
    end

end

#TODO (may be BaseState limited)

class InlineCbHandler < BaseState

    def initialize(callback_query_id)
        @callback_query_id = callback_query_id
    end

    def answer(**data) 
        Fiber.yield AnswerCallbackQueryAction.new(@callback_query_id, **data)
    end

    def select_activity(data)
    end

    def handle(cbdata)
        answer(text: "ok")
    end
end