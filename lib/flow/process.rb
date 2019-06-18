# frozen_string_literal: true

module Flow
  # Basic process
  class Process
    include ActByTag

    attr_reader :config, :context, :operations

    def initialize(config, context)
      @config = config
      @context = context
      @operations = []

      extend_by_tag
    end

    def start
      @operations = config['start'].map do |tag|
        new_config = config['operations'].find { |o| o['tag'] == tag }
        Operation.new(new_config, self, context)
      end
      run_iteration
    end

    def operation_completed(operation)
      build_next_operations(operation)
      run_iteration
    end

    def run_iteration
      iteration_operations = @operations.select(&:ready?)

      iteration_operations.map(&:complete)

      iteration_operations.map do |old_operation|
        build_next_operations(old_operation)
      end

      run_iteration if @operations.any?(&:ready?)
    end

    def build_next_operations(old_operation)
      return if old_operation.config[old_operation.status].nil?

      old_operation.config[old_operation.status].each do |operation_conf|
        operation_conf.each do |tag, _value|
          new_config = config['operations'].find { |o| o['tag'] == tag }
          new_operations = Operation.new(new_config, self, old_operation.context)
          @operations << new_operations
        end
      end
    end
  end
end
