module FetchLocationForecast
  class MapTemperatureToResponse < UseCase::Base
    def before
      @forecast = context.forecast
    end

    def perform
      temperatures = @forecast.temperatures.deep_symbolize_keys
      @forecast.temperatures = temperatures[:list].map { |it| it[:temp][:day]}
      context.response = @forecast.response
    end
  end
end
