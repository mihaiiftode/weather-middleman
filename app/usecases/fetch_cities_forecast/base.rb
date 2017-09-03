module FetchCitiesForecast
  class Base < UseCase::Base
    depends FetchExistingEntries, FilterExpiredEntries, FetchUnknownEntries, MapTemperatureToResponse

    def perform;
    end
  end
end
