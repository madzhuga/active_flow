# frozen_string_literal: true

module Flow
  class Process
    include ActByTag

    attr_accessor :config, :context, :operations, :tag, :status

    def self.create(config, context)
      process = new(config, context)
      process.create
    end

    def initialize(config, context)
      @config = config
      @context = context
      @status = 'new'
      @tag = @config['tag']
      @operations = []

      extend_by_tag
    end

    def create
      run_callback('create')

      @operations = config['start'].map do |tag|
        new_config = config['operations'].find { |o| o['tag'] == tag }
        Operation.create(new_config, self, context)
      end

      self
    end

    def start
      runner.run
    end

    def runner
      @runner ||= ProcessRunner.new(self)
    end

    def operation_completed(operation)
      runner.operation_completed(operation)
    end

    def complete
      @status = 'completed'
      status_changed
    end

    def status_changed
      run_callback('status_changed')
    end

    def run_callback(kind)
      Callbacks.run('process', kind, process: self)
      Callbacks.run(tag, kind, process: self)
    end

    def next_operations(operation)
      operation.config[operation.status]
    end
  end
end
