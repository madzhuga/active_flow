# frozen_string_literal: true

module Flow
  module Callbacks
    def self.add(target, kind, klaz)
      Thread.current['flow_callback'] ||= {}
      Thread.current['flow_callback'][target] ||= {}
      Thread.current['flow_callback'][target][kind] ||= []
      Thread.current['flow_callback'][target][kind] << klaz
    end

    def self.callbacks(target, kind)
      Thread.current['flow_callback']&.dig(target, kind)
    end

    def self.clear
      Thread.current['flow_callback'].clear
    end

    def self.run(target, kind, context)
      callbacks(target, kind)&.each do |callback|
        callback.new(context).run
      end
    end
  end
end
