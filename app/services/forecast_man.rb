require "open_weather"

class ForecastMan
  FORECAST_FOR_10_DAYS = 10.freeze
  FORECAST_FOR_1_DAY = 1.freeze

  def initialize(units, client = nil)
    @options = { units: units, APPID: ENV["WEATHER_MAN_API_KEY"] }
    @client = client || OpenWeather::ForecastDaily
  end

  def temperature_ten_days(id)
    @options[:cnt] = FORECAST_FOR_10_DAYS
    temperature(id)
  end

  def next_day_temperature(id)
    @options[:cnt] = FORECAST_FOR_1_DAY
    temperature(id)
  end

  private

  def temperature(id)
    @client.city_id(id, @options)
  end
end
