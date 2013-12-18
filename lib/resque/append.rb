require "resque/append/version"

module Resque
  module Append
    def self.disable!
      self.enabled = false
    end

    def self.enable!
      self.enabled = true
    end

    def self.reset!
      Resque.queues.each { |q| Resque.remove_queue(q) }
    end

    def self.enabled
      @enabled
    end

    def self.enabled?
      !!@enabled
    end

    def self.enabled=(enabled)
      @enabled = !!enabled
      Resque::Append.work if @enabled
      @enabled
    end

    def self.idle!
      @processing = false
    end

    def self.processing!
      @processing = true
    end

    def self.processing=(processing)
      @processing = !!processing
    end

    def self.processing?
      !!@processing
    end

    def self.worker=(worker)
      @worker = worker
    end

    def self.worker
      @worker ||= Resque::Worker.new("*").tap do |w|
        w.cant_fork  = true
        w.term_child = true
      end
    end

    def self.work
      if Resque::Append.enabled? && !Resque::Append.processing?
        Resque::Append.processing!
        Resque::Append.worker.work(0)
        Resque::Append.idle!
      end
    end

    def after_enqueue_append(*args)
      Resque::Append.work
    end

    # resque-scheduler integration
    def after_schedule_append(*args)
      if Resque::Append.enabled?
        # delayed runs last, popped alphabetically when worker is *
        Resque.enqueue_to("zzzzzzed", self, *args)
      end
    end
  end
end
