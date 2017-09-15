require_relative 'flowcounter_simple'

class Fluent::FlowCounterSimpleOutput < Fluent::Output
  Fluent::Plugin.register_output('flowcounter_simple', self)

  # To support log_level option implemented by Fluentd v0.10.43
  unless method_defined?(:log)
    define_method("log") { $log }
  end

  include ::Fluent::FlowcounterSimple

  def emit(tag, es, chain)
    process(tag, es)
    chain.next
  end
end
