module FetchCitiesForecast
  class FetchExistingEntries < UseCase::Base
    def before
      @cache_repository = context.cache_repository || CacheRepository.new
      @city_ids = context.city_ids
      @unknown_forecasts = []
      @forecasts = []
    end

    def perform
      @city_ids.each(&method(:create_forecast)) unless @city_ids.empty?
      context.forecasts = @forecasts
      context.unknown_forecasts = @unknown_forecasts
    end

    private

    def create_forecast(id)
      forecast = Forecast.new(city_id: id, type: ForecastType::NEXT_DAY)
      handle_cache_response(forecast, @cache_repository.get_forecast(forecast.key))
    end

    def handle_cache_response(forecast, response)
      if response.present?
        forecast.map_value(response)
        @forecasts << forecast
      else
        @unknown_forecasts << forecast
      end
    end
  end
end
