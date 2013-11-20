require 'helper'

class FlowCounterSimpleOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end
  
  CONFIG = %[
    unit second
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::FlowCounterSimpleOutput, tag).configure(conf)
  end

  def test_configure
    assert_nothing_raised {
      d = create_driver('')
    }
    assert_nothing_raised {
      d = create_driver(CONFIG)
    }
  end

  def test_emit
    d1 = create_driver(CONFIG, 'test.tag1')
    d1.run do
      10.times do
        d1.emit({'message'=> 'a' * 100})
        d1.emit({'message'=> 'b' * 100})
        d1.emit({'message'=> 'c' * 100})
      end
    end
    r1 = d1.instance.flush_emit(60)
  end
end
