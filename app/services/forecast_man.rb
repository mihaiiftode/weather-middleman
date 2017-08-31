require "open_weather"

class ForecastMan
  FORECAST_FOR = 10.freeze

  def initialize(units, client = nil)
    @options = { units: units, APPID: ENV["WEATHER_MAN_API_KEY"] }
    @client = client || OpenWeather::ForecastDaily
  end

  def temperatures(ids)
    @options[:cnt] = FORECAST_FOR
    ids.collect { |it| temperature(it) }
  end

  def next_day_temperature(id)
    @options[:cnt] = 1
    temperature(id)
  end

  private

  def temperature(id)
    @client.city_id(id, @options)
  end
end
