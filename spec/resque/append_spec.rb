require 'spec_helper'
describe "resque-append" do
  before(:each) do
    JobAudit.reset!
    Resque.remove_queue(:default)
  end

  context "when enabled" do
    before(:each) do
      Resque::Append.enable!
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

  context "when disabled" do
    before(:each) do
      Resque::Append.disable!
    end

    it "should not run anything" do
      Resque.enqueue(JobA)

      JobAudit.events.should == []
    end

    it "should not run anything" do
      Resque.enqueue_in(30, JobA)

      JobAudit.events.should == []
    end
  end
end
