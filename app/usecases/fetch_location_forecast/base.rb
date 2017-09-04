module FetchLocationForecast
  class Base < UseCase::Base
    depends FetchExistingEntry, FetchAndCacheEntry, MapTemperatureToResponse

    def perform; end
  end
end
