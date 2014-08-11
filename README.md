# SimpleBenchmark

A simple gem to benchmark spots in your Ruby / Rails code

## Installation

Install via Rubygems, or add it to your application's Gemfile:

    $ gem install simple-benchmark
    
    # Gemfile
    gem 'simple-benchmark'

## Usage

Use this library to benchmark portions of your code and save the results to a specified log target.  To use it by itself, you can wrap your code in a `run` block:

    benchmarker = SimpleBenchmark.new('execution time')
    benchmarker.run { sleep(1) }

This will log the execution time to a file called `benchmark.log` or will use `Rails.logger` if defined.  You can override this setting by specifying a different logger globally, or per-usage:

    SimpleBenchmark.logger = Logger.new('alternate.log')
    benchmarker = SimpleBenchmark.new('execution time', :logger => Logger.new('alternate.log'))
    
While you can use this by itself, it's better to use it through the provided helper -- it makes the invocation simpler and will allow you to disable all logging globally (in production, for example):

    class MyClass
      include SimpleBenchmark::Helper
      
      def do_a_thing
        log_execution_time_for('doing a thing') do
          sleep(1)
          'done'
        end
      end

Calling `MyClass#do_a_thing` will log the execution to the configured log target.  If you want to disable logging altogether, simply set `SimpleBenchmark.enabled = false` in a global configuration file (e.g. `config/initializers/benchmarking.rb` if you're using it in a Rails app).

    

