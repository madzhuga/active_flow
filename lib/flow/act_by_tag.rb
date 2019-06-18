# frozen_string_literal: true

module Flow
  module ActByTag
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
end
