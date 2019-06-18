# frozen_string_literal: true

require 'pry'

module Flow
  # Very basic operation implementation
  class Operation
    include ActByTag

    attr_reader :config, :context, :process
    attr_accessor :status

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
    end

    def runner
      OperationRunner.new(self)
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
