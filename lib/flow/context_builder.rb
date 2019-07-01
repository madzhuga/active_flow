module Flow
  class ContextBuilder
    def self.build(old_context)
      new(old_context).build
    end

    def initialize(old_context)
      @old_context = old_context
    end

    def build
      @old_context.except(*isolated_elements)
    end

    def isolated_elements
      Thread.current['flow_context'] ||= []
    end
  end
end
