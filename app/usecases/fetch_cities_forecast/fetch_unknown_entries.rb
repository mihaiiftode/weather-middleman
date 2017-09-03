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
      @unknown_forecasts.map { |it| it.temperatures = @forecast_man.next_day_temperature(it.city_id) }
      @forecasts += @unknown_forecasts
      context.forecasts = @forecasts
    end
  end
end
