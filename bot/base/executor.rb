
#is used to change actions back-end
#(is an example of bridge pattern)


class ObtainContextAction < BaseAction 
    def exec(ctx)
        return ctx
    end
end

class BaseActionExecutor 

    def expect_text
        throw 'not implemented'
    end

    def say(text)
        throw 'not implemented'
    end 

    def __ctx 
        Fiber.yield ObtainContextAction.new
    end

end
