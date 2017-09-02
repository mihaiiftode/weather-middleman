module FetchCitiesForecast
  class FetchUnknownEntries < UseCase::Base
    UNITS = "metric".freeze

    def before
      @units = context.units || UNITS
      @forecast_man = context.forecast_man || ForecastMan.new(@units)
      @unknown_forecasts = context.unknown_forecasts
      @forecasts = context.forecasts
    end

    def perform
      ids = @unknown_forecasts.collect(&:city_id)
      temperatures = @forecast_man.next_day_temperatures(ids)
      @unknown_forecasts.each_with_index { |item, index| item.temperatures = temperatures[index] }
      @forecasts += @unknown_forecasts
      context.forecasts = @forecasts
    end
  end
end
