module FetchCitiesForecast
  class MapTemperatureToResponse < UseCase::Base
    SMALL_THRESHOLD = "-999".freeze

    def before
      @forecasts = context.forecasts
      @threshold = context.threshold || SMALL_THRESHOLD
    end

    def perform
      context.response = @forecasts.each(&method(:map_response)).select { |it| it.temperatures > Integer(@threshold) }
        .map(&:response)
    end

    private

    def map_response(forecast)
      temperatures = forecast.temperatures.deep_symbolize_keys
      forecast.temperatures = temperatures[:list][0][:temp][:day]
    end
  end
end
