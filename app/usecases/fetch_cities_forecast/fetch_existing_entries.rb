module FetchCitiesForecast
  class FetchExistingEntries < UseCase::Base
    def before
      @cache_repository = context.cache_repository || CacheRepository.new
      @city_ids = context.city_ids
      @unknown_forecasts = []
      @forecasts = []
    end

    def perform
      @forecasts << @city_ids.collect(&method(:create_forecast))
      @unknown_forecasts = @forecasts.collect{ |forecast| forecast.temperatures.blank?}
    end

    private

    def create_forecast(id)
      forecast = Forecast.new({ city_id: id, type: ForecastType::NEXT_DAY })
      forecast.expiry_date = @cache_repository.get_forecast(forecast.key)
    end
  end
end
