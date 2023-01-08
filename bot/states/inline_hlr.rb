

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

    #TODO move to helpers
    def exec_inline_query_action(data)
        begin
            data = OpenStruct.new(
                Marshal.load(Base64.decode64(data)))
            self.send(data.name, *data.args, **data.vargs)
        rescue => err
            puts err.to_s.red
            eval(data)
        end
    end


    def handle(cbdata)
        data = InlineKeyboard.find_by(id: cbdata)

        return answer() unless data

        case exec_inline_query_action(data.dump)
        in {page: {text:, kb:}}
            answer()
            edit_text(message_id(), text, kb.to_h)
        in {answer:}
            answer(text: answer)
        else
            answer()
        end

    end

end
