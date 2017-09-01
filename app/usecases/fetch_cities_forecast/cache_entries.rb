module FetchCitiesForecast
  class CacheEntries < UseCase::Base
    def before
      @forecasts_to_cache = context.unknown_forecasts
      @cache_repository = context.cache_repository || CacheRepository.new
    end

    def perform
      @forecasts_to_cache.each { |it| it.expiry_date = Time.now.at_end_of_day }
      @cache_repository.add_forecasts(@forecasts_to_cache)
    end
  end
end
