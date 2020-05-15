# frozen_string_literal: true

require 'rest-client'
require 'json'

class ExchangeService
  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount
  end

  def call
    if @source_currency == 'BTC'
      TobtcService.new(@source_currency, @amount).call
    else
      value = get_exchange
      value * @amount.to_f
    end
  end

  private

  def get_exchange
    exchange_api_url = Rails.application.credentials[:currency_api_url]
    exchange_api_key = Rails.application.credentials[:currency_api_key]
    url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
    res = RestClient.get(url)
    Float(JSON.parse(res.body)['currency'][0]['value'])
  end
end
