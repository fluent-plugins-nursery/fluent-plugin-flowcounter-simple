require_relative 'flowcounter_simple'

class Fluent::FlowCounterSimpleFilter < Fluent::Filter
  Fluent::Plugin.register_filter('flowcounter_simple', self)

  include ::Fluent::FlowcounterSimple

  def filter_stream(tag, es)
    process(tag, es)
    es
  end
end if defined?(Fluent::Filter)
