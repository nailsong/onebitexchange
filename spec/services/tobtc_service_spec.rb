require 'rails_helper'
require './app/services/tobtc_service'

describe TobtcService do
  it '#call' do
    # setup
    currency = 'USD'
    value = rand(0..9999)

    # exercise
    response = TobtcService.new(currency, value).call

    # verify
    expect(response[:status]).to eq(200)
  end
end
