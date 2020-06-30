require 'fluent/plugin/output'
require_relative 'flowcounter_simple'

module Fluent::Plugin
  class FlowCounterSimpleOutput < Output
    Fluent::Plugin.register_output('flowcounter_simple', self)

    include ::Fluent::FlowcounterSimple

    def prefer_buffered_processing
      false
    end

    def multi_workers_ready?
      true
    end

    def process(tag, es)
      process_count(tag, es)
    end
  end
end
