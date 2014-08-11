require 'spec_helper'

describe SimpleBenchmark do
  def remove_log_files(*names)
    names.each {|n| FileUtils.rm_f(n) }
  end
  
  def log_lines(filename)
    File.read(filename).split(/\n+/)
  end
  
  def reset_global_logger
    described_class.instance_variable_set(:@logger, nil)
  end
    
  
  describe ".enabled?" do
    it "is true by default" do
      described_class.enabled?.should be(true)
    end
    
    it "is false when set to false" do
      described_class.enabled = false
      described_class.enabled?.should be(false)
    end
  end
  
  describe ".logger" do
    before { reset_global_logger }
    after  { reset_global_logger }
    
    it "uses a default file" do
      Logger.stub(:new).with('benchmark.log').and_return('logger')
      described_class.logger.should == 'logger'
    end
    
    it "uses the Rails logger if available" do
      Rails = Class.new { def self.logger; 'rails logger'; end }
      
      described_class.logger.should == 'rails logger'
      
      Object.send(:remove_const, :Rails)
    end
    
    it "uses the user-provided logger" do
      described_class.logger = 'logger'
      described_class.logger.should == 'logger'
    end
  end
  
  describe "#run" do
    let(:log_files) { %w(benchmark.log alternate.log) }
    
    before { remove_log_files(*log_files) }
    after  { remove_log_files(*log_files) }
    
    let(:loggable) { lambda { 'done' } }
    
    it "logs the response time" do
      subject  = described_class.new('code')
      subject.run { sleep(0.1) }
      
      lines = log_lines('benchmark.log')

      lines.length.should == 2
      lines.last.should match(/code:\s+\d+\.\d+\s+second\(s\)/)
    end
    
    it "returns the value of the original block" do
      subject = described_class.new('code')
      subject.run { 'done' }.should == 'done'
    end
    
    it "uses an alternate logger when requested" do
      logger  = Logger.new('alternate.log')
      subject = described_class.new('alternate', logger)

      expect { subject.run { 'done' } }.to change { log_lines('alternate.log').length }.by(1)
    end
  end
  
end
