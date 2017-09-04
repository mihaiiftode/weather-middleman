module FetchLocationForecast
  class FetchAndCacheEntry < UseCase::Base
    UNITS = "metric".freeze

    def before
      @forecast_man = context.forecast_man || ForecastMan.new(UNITS)
      @cache_repository = context.cache_repository || CacheRepository.new
      @forecast = context.forecast
      @city_id = context.city_id
    end

    def perform
      return unless @forecast.expired?

      @forecast.temperatures = @forecast_man.temperature_ten_days(@city_id)
      @forecast.expiry_date = Time.now.at_end_of_day
      @cache_repository.add_forecast(@forecast)
    end
  end
end
