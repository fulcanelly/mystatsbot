

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

    attr_accessor :cbq

    def initialize(cbq)
        @cbq = cbq
    end

    def callback_query_id() = cbq.id 

    def message_id() = cbq.message.message_id
    
        
    def answer(**data) 
        Fiber.yield AnswerCallbackQueryAction.new(callback_query_id, **data)
    end

    def select_activity(data)
    end

    include CommonInline

    def handle(cbdata)
        answer()

        data = myself.inline_keyboards.find_by(id: cbdata)

        return unless data        

        case eval(data.dump)
        in {page: {text:, kb:}}
            edit_text(message_id(), text, kb.to_h)
        else 

        end


    end
    
    
end