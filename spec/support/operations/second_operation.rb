module SecondOperation
  def perform
    context['log'] << 'Second Operation'
  end
end
