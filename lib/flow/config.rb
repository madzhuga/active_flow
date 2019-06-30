# frozen_string_literal: true

module Flow
  # Basic configuration for a processes
  class Config
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def self.load(dir = '.')
      config = {}
      Dir[[dir, '*.yml'].join('/')].each do |file_name|
        pc = YAML.load_file(file_name)
        config[pc['tag']] = pc
      end

      new(config)
    end
  end
end
