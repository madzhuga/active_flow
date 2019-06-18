# frozen_string_literal: true

require 'pry'

module Flow
  # Very basic operation implementation
  class Operation
    include ActByTag

    attr_reader :config, :context, :status, :process

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
      perform if respond_to?(:perform)
      @status = 'completed'
      process.operation_completed(self) if manual?
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
