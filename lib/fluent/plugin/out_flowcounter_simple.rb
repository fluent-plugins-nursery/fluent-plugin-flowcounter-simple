class Fluent::FlowCounterSimpleOutput < Fluent::Output
  Fluent::Plugin.register_output('flowcounter_simple', self)

  config_param :indicator, :string, :default => 'num'
  config_param :unit, :string, :default => 'second'
  config_param :comment, :string, :default => nil

  attr_accessor :last_checked

  def configure(conf)
    super

    @indicator_proc =
      case @indicator
      when 'num'  then Proc.new {|record| 1 }
      when 'byte' then Proc.new {|record| record.to_msgpack.size }
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
        raise RuntimeError, "@unit must be one of second/minute/hour/day"
      end

    @output_proc =
      if @comment
        Proc.new {|count| "plugin:out_flowcounter_simple\tcount:#{count}\tindicator:#{@indicator}\tunit:#{@unit}\tcomment:#{@comment}" }
      else
        Proc.new {|count| "plugin:out_flowcounter_simple\tcount:#{count}\tindicator:#{@indicator}\tunit:#{@unit}" }
      end

    @count = 0
    @mutex = Mutex.new
  end

  def start
    super
    start_watch
  end

  def shutdown
    super
    @watcher.terminate
    @watcher.join
  end

  def countup(count)
    @mutex.synchronize {
      @count = (@count || 0) + count
    }
  end

  def flush_emit(step)
    count, @count = @count, 0
    if count > 0
      $log.info @output_proc.call(count)
    end
  end

  def start_watch
    # for internal, or tests only
    @watcher = Thread.new(&method(:watch))
  end

  def watch
    # instance variable, and public accessable, for test
    @last_checked = Fluent::Engine.now
    while true
      sleep 0.1
      if Fluent::Engine.now - @last_checked >= @tick
        now = Fluent::Engine.now
        flush_emit(now - @last_checked)
        @last_checked = now
      end
    end
  end

  def emit(tag, es, chain)
    count = 0
    es.each {|time,record|
      count += @indicator_proc.call(record)
    }
    countup(count)

    chain.next
  end
end
