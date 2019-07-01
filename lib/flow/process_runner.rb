# frozen_string_literal: true

module Flow
  class ProcessRunner
    attr_reader :process

    def initialize(process)
      @process = process
    end

    def operation_completed(operation)
      build_next_operations(operation)
      run
    end

    def run
      iteration_operations = process.operations.select(&:ready?)

      iteration_operations.map(&:complete)

      iteration_operations.map do |old_operation|
        build_next_operations(old_operation)
      end

      if process.operations.any?(&:ready?)
        run
      else
        complete
      end
    end

    def complete
      process.complete
    end

    def build_next_operations(operation)
      return if operation.config[operation.status].nil?

      next_operations(operation).each do |operation_conf|
        operation_conf.each do |tag, _value|
          new_context = ContextBuilder.build(operation.context)

          process.operations << Operation.create(
            operation_config(tag), process, new_context
          )
        end
      end
    end

    def operation_config(tag)
      config['operations'].find { |o| o['tag'] == tag }
    end

    def config
      process.config
    end

    def next_operations(operation)
      process.next_operations(operation)
    end
  end
end
