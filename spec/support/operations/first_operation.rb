# frozen_string_literal: true

module FirstOperation
  def perform
    context['log'] << 'First Operation'
  end
end
