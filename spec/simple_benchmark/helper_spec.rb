require 'spec_helper'

class Example
  include SimpleBenchmark::Helper
  
  def do_a_thing
    log_execution_for('something') do
      sleep(0.1)
      'done'
    end
  end
  
  def do_a_thing_with_another_logger(logger)
    log_execution_for('something else', :logger => logger) do
      'done'
    end
  end
end

describe SimpleBenchmark::Helper do
  describe "#log_execution_for" do
    let(:benchmarker) { double(:benchmarker) }
    
    subject { Example.new }
    
    it "logs execution for the code block" do
      benchmarker.should_receive(:run)
      
      SimpleBenchmark.stub(:new).with('something', nil).and_return(benchmarker)
      
      subject.do_a_thing
    end
    
    it "returns the value of the block" do
      subject.do_a_thing.should == 'done'
    end
    
    it "passes in a custom logger" do
      benchmarker.stub(:run)
      logger = 'logger'
      
      SimpleBenchmark.should_receive(:new).with('something else', 'logger').and_return(benchmarker)
      
      subject.do_a_thing_with_another_logger('logger')
    end
    
    context "when benchmarking is disabled" do
      before { SimpleBenchmark.enabled = false }
      after  { SimpleBenchmark.enabled = true  }
    
      it "does not log execution" do
        SimpleBenchmark.should_receive(:new).never
      
        subject.do_a_thing
      end
      it "returns the value of the block" do
        subject.do_a_thing.should == 'done'
      end
    end
  end
end