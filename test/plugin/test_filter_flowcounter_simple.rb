require_relative '../helper'
require "test/unit/rr"

class FlowCounterSimpleFilterTest < Test::Unit::TestCase
  include Fluent

  def setup
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  CONFIG = %[
    unit second
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::FilterTestDriver.new(Fluent::FlowCounterSimpleFilter).configure(conf, true)
  end

  def test_filter
    msgs = []
    10.times do
      msgs << {'message'=> 'a' * 100}
      msgs << {'message'=> 'b' * 100}
    end
    d = create_driver
    filtered, out = filter(d, msgs)
    assert_equal msgs, filtered
    assert( out.include?("count:20"), out )
  end

  private

  def filter(d,  msgs)
    stub(d.instance.output).start
    stub(d.instance.output).shutdown
    d.run {
      msgs.each {|msg|
        d.filter(msg, @time)
      }
    }
    out = capture_log(d.instance.output.log) do
      d.instance.flush_emit(0)
    end
    filtered = d.filtered_as_array
    filtered_msgs = filtered.map {|m| m[2] }
    [filtered_msgs, out]
  end
end if defined?(Fluent::Filter)
