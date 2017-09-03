module FetchCitiesForecast
  class MapTemperatureToResponse < UseCase::Base
    def before
      @forecasts = context.forecasts
      @threshold = context.threshold
    end

    def perform
      context.forecasts = @forecasts.each(&method(:map_response)).select { |it| it.temperatures > @threshold}
    end

    private

    def map_response(forecast)
      temperatures = JSON.parse(forecast.temperatures, symbolize_names: true)

      forecast.temperatures = temperatures[:list][0][:temp][:day]
    end
  end
end
