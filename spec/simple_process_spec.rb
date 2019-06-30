# frozen_string_literal: true

require 'spec_helper'

describe Flow::Manager do
  let(:config) do
    Flow::Config.load('./spec/support/processes/simple_process/')
  end

  let(:process) { described_class.start('first_process', { 'log' => [] }, config) }

  it 'runs all operations' do
    expect(process.context['log'].join(' && ')).to eq(
      'First Operation && Second Operation && Third Operation'
    )
  end
end
