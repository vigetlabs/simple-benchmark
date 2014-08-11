require 'benchmark'
require 'logger'

require 'simple_benchmark/version'

class SimpleBenchmark
  autoload :Helper, 'simple_benchmark/helper'
  
  class << self
    attr_writer :logger, :enabled
  end

  self.enabled = true

  def self.logger
    @logger ||= default_logger
  end
  
  def self.enabled?
    @enabled == true
  end

  def initialize(description, logger = nil)
    @description = description
    @logger      = logger
  end

  def run(&block)
    result = nil
    report = Benchmark.measure do
      result = block.call
    end

    logger.info("#{@description}: #{report.real} second(s)")
    result
  end
  
  private
  
  def self.default_logger
    defined?(Rails) ? Rails.logger : Logger.new('benchmark.log')
  end
  
  def logger
    @logger ||= self.class.logger
  end
  
end
