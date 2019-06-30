# frozen_string_literal: true

module Flow
  class Process
    include ActByTag

    attr_reader :config, :context, :operations

    def self.create(config, context)
      process = new(config, context)
      process.create
    end

    def initialize(config, context)
      @config = config
      @context = context
      @operations = []

      extend_by_tag
    end

    def create
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

    def next_operations(operation)
      operation.config[operation.status]
    end
  end
end
