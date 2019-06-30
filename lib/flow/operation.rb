# frozen_string_literal: true

require 'pry'

module Flow
  # Very basic operation implementation
  class Operation
    include ActByTag

    attr_reader :config, :context, :process
    attr_accessor :status

    def self.create(config, process, context)
      operation = new(config, process, context)
      operation.create
      operation
    end

    def create
      run_callback('create')
    end

    def initialize(config, process, context)
      @config = config
      @process = process
      @context = context
      @status = 'new'

      extend_by_tag
    end

    def tag
      @config['tag']
    end

    def complete
      runner.complete
      status_changed
    end

    def status_changed
      run_callback('status_changed')
    end

    def run_callback(kind)
      Callbacks.run('operation', kind, operation: self)
      Callbacks.run(tag.to_s, kind, operation: self)
    end

    def runner
      @runner ||= OperationRunner.new(self)
    end

    def completed?
      @status == 'completed'
    end

    def ready?
      status == 'new' && !manual?
    end

    def waiting?
      status == 'new' && manual?
    end

    def manual?
      @config['manual'] == true
    end
  end
end
