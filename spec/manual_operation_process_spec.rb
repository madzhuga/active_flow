# frozen_string_literal: true

require 'spec_helper'

describe Flow::Manager do
  let(:config) do
    Flow::Config.new.tap { |config| config.load('./spec/support/processes/manual_operation_process/') }
  end

  let!(:process) { described_class.start('manual_operation_process', { 'log' => [] }, config) }

  it 'finishes first non-manual operation' do
    expect(operation_by_tag('first_operation')).to be_completed
  end

  it 'creates manual operation' do
    expect(operation_by_tag('second_operation')).to be_manual
    expect(operation_by_tag('second_operation')).to be_waiting
  end

  it 'stops on manual operation' do
    expect(process.operations.size).to eq 2
    expect(operation_by_tag('third_operation')).to be_nil
  end

  it 'continues process on manual operation completed' do
    expect { operation_by_tag('second_operation').complete }
      .to change { operation_by_tag('third_operation') }.from(nil)
  end

  def operation_by_tag(tag)
    process.operations.find { |o| o.tag == tag }
  end
end
