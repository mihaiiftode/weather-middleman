module FetchCitiesForecast
  class MapTemperatureToResponse < UseCase::Base
    def before
      @forecasts = context.forecasts
      @threshold = context.threshold
    end

    def perform
      context.response = @forecasts.each(&method(:map_response)).select { |it| it.temperatures > Integer(@threshold) }
                              .map { |it| it.response }
    end

    private

    def map_response(forecast)
      temperatures = forecast.temperatures
      forecast.temperatures = temperatures["list"][0]["temp"]["day"]
    end
  end
end
