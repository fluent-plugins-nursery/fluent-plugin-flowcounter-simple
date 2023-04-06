require "test-unit"
require "fluent/test"

module Helper
  def normalize_logs(logs)
    logs.collect do |log|
      log.gsub(/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [-+]\d{4} \[info\]: /, "") 
    end
  end
end
