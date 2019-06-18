# frozen_string_literal: true

module SecondOperation
  def perform
    context['log'] << 'Second Operation'
  end
end
