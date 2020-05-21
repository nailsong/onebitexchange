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
    if @target_currency == 'BTC'
      to_btc
    elsif @source_currency == 'BTC'
      from_btc
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

  def to_btc
    explorer.to_btc(@source_currency, @amount)
  end

  def from_btc
    get_btc * @amount.to_f
  end

  def explorer
    Blockchain::ExchangeRateExplorer.new
  end

  def get_btc
    value = explorer.get_ticker
    value[@target_currency].last
  end
end
