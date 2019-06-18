# frozen_string_literal: true

module Flow
  # Manager is used to start and control processes
  class Manager
    def self.config
      @config ||= begin
        conf = Config.new
        conf.load
        conf
      end
    end

    def self.start(tag, context, configuration = nil)
      @config = configuration unless configuration.nil?

      process_config = config.config[tag]
      process = Process.new(process_config, context)
      process.start
      process
    end
  end
end
