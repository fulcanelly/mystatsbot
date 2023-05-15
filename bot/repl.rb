require_relative './tg-toolkit/src/autoload'
require 'irb'

Autoloader.new.load_from(__dir__)

return if __FILE__ != $0

IRB.start
