# frozen_string_literal: true

require 'spec_helper'

describe Flow::Manager do
  let(:config) { Flow::Config.load('./spec/support/processes/simple_process/') }
  let(:process) { described_class.start('first_process', { 'log' => [] }, config) }
  let(:process_callback) do
    Class.new do
      def initialize(context)
        @context = context
      end

      def run
        @context[:process].context['log'] << 'Process create callback'
      end
    end
  end

  let(:operation_callback) do
    Class.new do
      def initialize(context)
        @context = context
      end

      def run
        @context[:operation].process.context['log'] << 'Operation create callback'
      end
    end
  end

  let(:tag_callback) do
    Class.new do
      def initialize(context)
        @context = context
      end

      def run
        @context[:operation].process.context['log'] << 'Second operation create callback'
      end
    end
  end

  before do
    Flow::Callbacks.add('process', 'create', process_callback)
    Flow::Callbacks.add('operation', 'create', operation_callback)
    Flow::Callbacks.add('second_operation', 'create', tag_callback)
  end

  after do
    Flow::Callbacks.clear
  end

  it 'runs all operations' do
    expect(process.context['log'].join(' && ')).to eq(
      'Process create callback && Operation create callback && First Operation && Operation create callback && Second operation create callback && Second Operation && Operation create callback && Third Operation'
    )
  end
end
