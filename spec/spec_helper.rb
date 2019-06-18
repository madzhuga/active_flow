# frozen_string_literal: true
require './lib/flow/act_by_tag'

Dir['./lib/flow/*.rb'].each { |file| require file }
require './lib/flow.rb'
