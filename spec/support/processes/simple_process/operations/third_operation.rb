module ThirdOperation
  def perform
    context['log'] << 'Third Operation'
  end
end
