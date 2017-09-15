require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fluent/test'
require 'fluent/plugin/out_flowcounter_simple'
require 'fluent/plugin/filter_flowcounter_simple'

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
