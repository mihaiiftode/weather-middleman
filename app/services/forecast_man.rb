require "open_weather"

class ForecastMan
  FORECAST_FOR = 10.freeze

  def initialize(units, client = nil)
    @options = { units: units, APPID: ENV["WEATHER_MAN_API_KEY"] }
    @client = client || OpenWeather::ForecastDaily
  end

  def temperature_ten_days(id)
    @options[:cnt] = FORECAST_FOR
    temperature(id)
  end

  def next_day_temperatures(ids)
    @options[:cnt] = 1
    ids.collect { |it| temperature(it) }
  end

  private

  def temperature(id)
    @client.city_id(id, @options)
  end
end
