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

  @queue = :default

  def self.perform
    JobAudit.events << [self, 'started']

    Resque.enqueue(JobB)

    JobAudit.events << [self, 'finished']
  end
end

class JobB
  extend Resque::Append

  @queue = :default

  def self.perform
    JobAudit.events << [self, 'started']

    Resque.enqueue(JobC)
    Resque.enqueue_in(30, JobC)

    JobAudit.events << [self, 'finished']
  end
end

class JobC
  extend Resque::Append

  @queue = :default

  def self.perform
    JobAudit.events << [self, 'started']
    JobAudit.events << [self, 'finished']
  end
end
