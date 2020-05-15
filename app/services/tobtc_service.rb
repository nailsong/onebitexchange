# frozen_string_literal: true

require 'rest-client'
require 'json'

class TobtcService
  def initialize(currency, value)
    @currency = currency
    @value = value
  end

  def call
    get_btc
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  private

  def get_btc
    url = "https://blockchain.info/tobtc?currency=#{@currency}&value=#{@value}"
    response = RestClient.get(url)
    value = JSON.parse(response.body)
    result = { value: value }
    result.merge(status: response.code)
  end
end