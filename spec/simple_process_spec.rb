# frozen_string_literal: true

require 'spec_helper'

describe Pm::Manager do
  let(:process) { Pm::Manager.start('first_process', { 'log' => [] }, config) }

  let(:config) do
    Dir['./spec/support/processes/simple_process/operations/*.rb']
      .each { |file| require file }

    config = Pm::Config.new
    config.load('./spec/support/processes/simple_process/')
    config
  end

  it 'runs all operations' do
    expect(process.context['log'].join(' && ')).to eq(
      'First Operation && Second Operation && Third Operation'
    )
  end
end
