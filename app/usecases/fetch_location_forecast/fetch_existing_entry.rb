module FetchLocationForecast
  class FetchExistingEntry < UseCase::Base
    def before
      @cache_repository = context.cache_repository || CacheRepository.new
      @city_id = context.city_id
    end

    def perform
      create_forecast(@city_id) unless @city_id.blank?
    end

    private

    def create_forecast(id)
      forecast = Forecast.new(city_id: id, type: ForecastType::TEN_DAYS)
      handle_cache_response(forecast, @cache_repository.get_forecast(forecast.key))
    end

    def handle_cache_response(forecast, response)
      forecast.map_value(response) if response.present?
      context.forecast = forecast
    end
  end
end
