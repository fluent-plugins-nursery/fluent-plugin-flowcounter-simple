# Be lazy to to implement filter plugin, use output plugin instance
require_relative 'out_flowcounter_simple'
require 'forwardable'

class Fluent::FlowCounterSimpleFilter < Fluent::Filter
  Fluent::Plugin.register_filter('flowcounter_simple', self)

  extend Forwardable
  attr_reader :output
  def_delegators :@output, :configure, :start, :shutdown, :flush_emit

  def initialize
    super
    @output = Fluent::FlowCounterSimpleOutput.new
  end

  def filter_stream(tag, es)
    @output.emit(tag, es, Fluent::NullOutputChain.instance)
    es
  end
end if defined?(Fluent::Filter)
