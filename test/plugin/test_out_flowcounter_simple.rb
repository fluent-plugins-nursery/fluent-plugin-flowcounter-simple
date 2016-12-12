require_relative '../helper'
require 'fluent/test/driver/output'

class FlowCounterSimpleOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    unit second
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::FlowCounterSimpleOutput).configure(conf)
  end

  def test_configure
    assert_nothing_raised {
      create_driver('')
    }
    assert_nothing_raised {
      create_driver(CONFIG)
    }
    assert_nothing_raised {
      create_driver(CONFIG + %[indicator num])
    }
    assert_nothing_raised {
      create_driver(CONFIG + %[indicator byte])
    }
  end

  def test_num
    d1 = create_driver(CONFIG)
    out = capture_log(d1.instance.log) do
      d1.run(default_tag: 'test.tag1') do
        10.times do
          d1.feed({'message'=> 'a' * 100})
          d1.feed({'message'=> 'b' * 100})
          d1.feed({'message'=> 'c' * 100})
        end
        d1.instance.flush_emit(60)
      end
    end
    assert( out.include?("count:30"), out )
  end

  def test_byte
    d1 = create_driver(CONFIG + %[indicator byte])
    out = capture_log(d1.instance.log) do
      d1.run(default_tag: 'test.tag1') do
        10.times do
          d1.feed({'message'=> 'a' * 100})
          d1.feed({'message'=> 'b' * 100})
          d1.feed({'message'=> 'c' * 100})
        end
        d1.instance.flush_emit(60)
      end
    end
    assert( out.include?("count:3330"), out )
  end

  def test_comment
    d1 = create_driver(CONFIG + %[comment foobar])
    out = capture_log(d1.instance.log) do
      d1.run(default_tag: 'test.tag1') do
        1.times do
          d1.feed({'message'=> 'a' * 100})
          d1.feed({'message'=> 'b' * 100})
          d1.feed({'message'=> 'c' * 100})
        end
        d1.instance.flush_emit(60)
      end
    end
    assert( out.include?("comment:foobar"), out )
  end
end
