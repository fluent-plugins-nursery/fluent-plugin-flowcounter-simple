require 'fluent/plugin/filter'
require_relative 'flowcounter_simple'

module Fluent::Plugin
  class FlowCounterSimpleFilter < Filter
    Fluent::Plugin.register_filter('flowcounter_simple', self)

    include ::Fluent::FlowcounterSimple

    def filter_stream(tag, es)
      process_count(tag, es)
      es
    end
  end
end
