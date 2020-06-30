require 'rubygems'
require 'bundler'

require 'test/unit'
require 'test/unit/rr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fluent/test'

class Test::Unit::TestCase
  def capture_log(log)
    if defined?(Fluent::Test::TestLogger) and log.is_a?(Fluent::Test::TestLogger) # v0.14
      yield
      log.out.logs.join("\n")
    else
      begin
        tmp = log.out
        log.out = StringIO.new
        yield
        return log.out.string
      ensure
        log.out = tmp
      end
    end
  end
end
