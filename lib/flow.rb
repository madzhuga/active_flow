# frozen_string_literal: true

require 'yaml'

module Pm
  module ExtendableByTag
    def extend_by_tag
      module_name = @config['tag'].split('_').collect(&:capitalize).join

      module_defined = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
        defined? #{module_name}
      RUBY

      return unless module_defined

      singleton_class.class_eval(
        "include #{Object.const_get(module_name)}",
        __FILE__,
        __LINE__ - 2
      )
    end
  end

  # Basic configuration for a processes
  class Config
    attr_reader :config
    def load(dir = '.')
      @config ||= {}
      Dir[[dir, '*.yml'].join('/')].each do |file_name|
        pc = YAML.load_file(file_name)
        @config[pc['tag']] = pc
      end
    end
  end

  # Basic process
  class Process
    include ExtendableByTag

    attr_reader :config, :context

    def initialize(config, context)
      @config = config
      @context = context
      @operations = []

      extend_by_tag
    end

    def start
      @operations = config['start'].map do |tag|
        new_config = config['operations'].find { |o| o['tag'] == tag }
        Operation.new(new_config, context)
      end
      run_iteration
    end

    def run_iteration
      next_operations = @operations.select(&:ready?)
      next_operations.map(&:complete)

      next_operations.map do |old_operation|
        next if old_operation.config[old_operation.status].nil?

        build_next_operations(old_operation)
      end

      run_iteration if @operations.any?(&:ready?)
    end

    def build_next_operations(old_operation)
      old_operation.config[old_operation.status].each do |operation_conf|
        operation_conf.each do |tag, _value|
          new_config = config['operations'].find { |o| o['tag'] == tag }
          new_operations = Operation.new(new_config, old_operation.context)
          @operations << new_operations
        end
      end
    end
  end

  # Very basic operation implementation
  class Operation
    include ExtendableByTag

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
