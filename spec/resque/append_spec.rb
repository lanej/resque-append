require 'spec_helper'


class JobAudit 
  def self.events
    @events ||= []
  end

  def self.reset!
    @events = nil
  end
end
class JobA
  extend Resque::Append

  @queue = :job_a

  def self.perform
    JobAudit.events << [self, 'started']

    Resque.enqueue(JobB)

    JobAudit.events << [self, 'finished']
  end
end

class JobB
  extend Resque::Append

  @queue = :job_b

  def self.perform
    JobAudit.events << [self, 'started']

    Resque.enqueue(JobC)
    Resque.enqueue(JobC)

    JobAudit.events << [self, 'finished']
  end
end

class JobC
  extend Resque::Append

  @queue = :job_c

  def self.perform
    JobAudit.events << [self, 'started']
    JobAudit.events << [self, 'finished']
  end
end

describe "resque-append" do
  before(:each) do
    Resque::Append.enable!
    JobAudit.reset!
  end

  context "when a job enqueues another job" do
    it "should run the second job after the first has finished" do
      Resque.enqueue(JobA)

      JobAudit.events.should == [
        [JobA, 'started'],
        [JobA, 'finished'],
        [JobB, 'started'],
        [JobB, 'finished'],
        [JobC, 'started'],
        [JobC, 'finished'],
        [JobC, 'started'],
        [JobC, 'finished'],
      ]
    end
  end

  it "should conform to plugin standards" do
    Resque::Plugin.lint(Resque::Append)
  end
end
