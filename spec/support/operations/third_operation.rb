# frozen_string_literal: true

module ThirdOperation
  def perform
    context['log'] << 'Third Operation'
  end
end
