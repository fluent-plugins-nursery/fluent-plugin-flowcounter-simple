# Be lazy to to implement filter plugin, use output plugin instance
require_relative 'out_flowcounter_simple'
require 'forwardable'
require 'fluent/plugin/filter'

class Fluent::Plugin::FlowCounterSimpleFilter < Fluent::Plugin::Filter
  Fluent::Plugin.register_filter('flowcounter_simple', self)

  extend Forwardable
  attr_reader :output
  def_delegators :@output, :configure, :start, :shutdown, :flush_emit

  def initialize
    super
    @output = Fluent::Plugin::FlowCounterSimpleOutput.new
  end

  def filter_stream(tag, es)
    @output.process(tag, es)
    es
  end
end
