# frozen_string_literal: true

require 'spec_helper'

Dir['./spec/support/processes/simple_process/operations/*.rb'].each { |file| require file }

describe Flow::Manager do
  let(:config) do
    Flow::Config.new.tap { |config| config.load('./spec/support/processes/simple_process/') }
  end

  let(:process) { described_class.start('first_process', { 'log' => [] }, config) }

  it 'runs all operations' do
    expect(process.context['log'].join(' && ')).to eq(
      'First Operation && Second Operation && Third Operation'
    )
  end
end
