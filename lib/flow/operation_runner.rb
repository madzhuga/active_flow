# frozen_string_literal: true

module Flow
  class OperationRunner
    attr_reader :operation

    def initialize(operation)
      @operation = operation
    end

    def complete
      operation.perform if operation.respond_to?(:perform)
      operation.status = 'completed'
      operation.process.operation_completed(operation) if operation.manual?
    end
  end
end
