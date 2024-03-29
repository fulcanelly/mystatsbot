require 'active_record'
require 'active_support/duration'
require 'ostruct'
require 'net/http'
require 'json'
require 'cgi'
require 'open-uri'
require 'recursive-open-struct'
require 'logger'
require 'colored'
require 'awesome_print'
require 'base64'
require_relative './tg-toolkit/src/autoload'

return if __FILE__ != $0

Autoloader.new.load_from(__dir__)

token = ENV['TG_TOKEN']

raise 'env variable TG_TOKEN required' unless token
raise 'env variable TG_TOKEN required' if token.empty?

pp Config

file_lister = proc do
    list_all_rb_files()
end

class MyApplication < Application
    def _on_callback_query(cbq)
        user_id = cbq.from.id
        cbdata = cbq.data

        ctx = provider.find_by_user_id(user_id)

        last_exec = ctx.state.executor

        fiber = Fiber.new do
            InlineCbHandler.new(cbq).tap do |chandler|
                chandler.executor = TGExecutor.new
            end.handle(cbdata)
        end

        ctx.side_runner(fiber).tap do
            _1.first_run()
        end.flat_run()

        ctx.state.executor = last_exec
    end

    def setup_handlers()

        self.pipe.on_callback_query do |cbq|
            _on_callback_query(cbq)
        end

        super()
    end

end


CreateAll.new.change

HotReloader.new(file_lister).tap do |reloader|
    reloader.init
    reloader.entry_point do

        bot = Bot.new(token)
        pipe = EventPipe.new
        provider = ContextProvider.new(bot, MainMenuState)

        bot.connect

        MyApplication.new(bot, pipe, provider)
            .tap do |app|
                app.setup_handlers()
            #   app.run_ctxes()
                app.run()
            end
    end
    reloader.start
end
