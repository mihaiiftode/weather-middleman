module FetchCitiesForecast
  class Base < UseCase::Base
    depends FetchExistingEntries, FilterExpiredEntries, FetchUnknownEntries, CacheEntries, MapTemperatureToResponse

    def perform;
    end
  end
end
