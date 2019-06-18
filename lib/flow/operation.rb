# frozen_string_literal: true

module Flow
  # Very basic operation implementation
  class Operation
    include ActByTag

    attr_reader :config, :context, :status

    def initialize(config, context)
      @config = config
      @context = context

      extend_by_tag
    end

    def tag
      @config['tag']
    end

    def complete
      perform if respond_to?(:perform)
      @status = 'complete'
    end

    def ready?
      status.nil?
    end
  end
end
