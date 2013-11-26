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
    assert_nothing_raised {
      d = create_driver(CONFIG + %[indicator num])
    }
    assert_nothing_raised {
      d = create_driver(CONFIG + %[indicator byte])
    }
  end

  def test_num
    d1 = create_driver(CONFIG, 'test.tag1')
    d1.run do
      10.times do
        d1.emit({'message'=> 'a' * 100})
        d1.emit({'message'=> 'b' * 100})
        d1.emit({'message'=> 'c' * 100})
      end
    end
    log = capture_log { d1.instance.flush_emit(60) }
    assert( log.include?("count:30"), log )
  end

  def test_byte
    d1 = create_driver(CONFIG + %[indicator byte], 'test.tag1')
    d1.run do
      10.times do
        d1.emit({'message'=> 'a' * 100})
        d1.emit({'message'=> 'b' * 100})
        d1.emit({'message'=> 'c' * 100})
      end
    end
    log = capture_log { d1.instance.flush_emit(60) }
    assert( log.include?("count:3360"), log )
  end

private

  def capture_log
    tmp = $log.out
    $log.out = StringIO.new
    yield
    return $log.out.string
  ensure
    $log.out = tmp
  end
end
