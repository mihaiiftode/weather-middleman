module FetchCitiesForecast
  class FilterExpiredEntries < UseCase::Base
    def before
      @forecasts = context.forecasts
    end

    def perform
      unknown_forecasts = @forecasts.select { |it| Time.now > Time.parse(it.expiry_date) }
      @forecasts -= unknown_forecasts
      context.unknown_forecasts += unknown_forecasts
      context.forecasts = @forecasts
    end
  end
end
