class SimpleBenchmark
  module Helper
    def log_execution_for(description, options = {}, &block)
      if SimpleBenchmark.enabled?
        benchmark = SimpleBenchmark.new(description, options[:logger])
        benchmark.run(&block)
      else
        block.call
      end
    end
  end
end