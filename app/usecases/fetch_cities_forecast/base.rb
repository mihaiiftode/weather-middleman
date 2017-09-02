module FetchCitiesForecast
  class Base < UseCase::Base
    depends FetchExistingEntries

    def perform; end
  end
end
