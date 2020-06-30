require 'fluent/plugin_helper/thread'

module Fluent
  module FlowcounterSimple
    attr_accessor :last_checked

    def self.included(klass)
      klass.helpers :thread
      klass.config_param :indicator, :string, :default => 'num'
      klass.config_param :unit, :string, :default => 'second'
      klass.config_param :comment, :string, :default => nil
    end

    def configure(conf)
      super

      @indicator_proc =
        case @indicator
        when 'num'  then Proc.new { |es| es.size }
        when 'byte' then Proc.new { |es|
                           count = 0
                           es.each { |time, record|
                             count += record.to_msgpack.size
                           }
                           count
                         }
        else
          raise Fluent::ConfigError, "flowcounter-simple count allows num/byte"
        end
      @unit =
        case @unit
        when 'second' then :second
        when 'minute' then :minute
        when 'hour' then :hour
        when 'day' then :day
        else
          raise Fluent::ConfigError, "flowcounter-simple unit allows second/minute/hour/day"
        end
      @tick =
        case @unit
        when :second then 1
        when :minute then 60
        when :hour then 3600
        when :day then 86400
        else
          raise Fluent::ConfigError, "@unit must be one of second/minute/hour/day"
        end

      @type_str = self.is_a?(Fluent::Plugin::Filter) ? 'filter' : 'out'
      @output_proc =
        if @comment
          Proc.new { |count| "plugin:#{@type_str}_flowcounter_simple\tcount:#{count}\tindicator:#{@indicator}\tunit:#{@unit}\tcomment:#{@comment}" }
        else
          Proc.new { |count| "plugin:#{@type_str}_flowcounter_simple\tcount:#{count}\tindicator:#{@indicator}\tunit:#{@unit}" }
        end

      @count = 0
      @mutex = Mutex.new
    end

    def start
      super
      thread_create(:flowcounter_simple_watch, &method(:watch))
    end

    def shutdown
      super
    end

    def countup(count)
      @mutex.synchronize {
        @count = (@count || 0) + count
      }
    end

    def flush_emit(step)
      count, @count = @count, 0
      if count > 0
        log.info @output_proc.call(count)
      end
    end

    def watch
      # instance variable, and public accessable, for test
      @last_checked = Fluent::EventTime.now
      while thread_current_running?
        sleep 0.1
        if Fluent::EventTime.now - @last_checked >= @tick
          now = Fluent::EventTime.now
          flush_emit(now - @last_checked)
          @last_checked = now
        end
      end
    end

    def process_count(tag, es)
      countup(@indicator_proc.call(es))
    end
  end
end
