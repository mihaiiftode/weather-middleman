require "test_helper"

describe FetchCitiesForecast::CacheEntries do
  describe "perform" do
    let(:unknown_forecasts) { [entry_to_cache1, entry_to_cache2] }
    let(:cache_repository) { MiniTest::Mock.new }
    let(:context) { { unknown_forecasts: unknown_forecasts, cache_repository: cache_repository } }
    let(:entry_to_cache1) do
      Forecast.new(
          city_id: 2_618_425,
          type: ForecastType::TEN_DAYS,
          expiry_date: nil,
          temperatures: {}
      )
    end
    let(:entry_to_cache2) do
      Forecast.new(
          city_id: 2_950_096,
          type: ForecastType::TEN_DAYS,
          expiry_date: nil,
          temperatures: {}
      )
    end

    subject { FetchCitiesForecast::CacheEntries.perform(context) }

    describe "unknown_forecasts has entries to cache" do
      it "tries to cache the entries" do
        cache_repository.expect(:add_forecasts, nil, [[entry_to_cache1, entry_to_cache2]])

        subject

        cache_repository.verify
      end

      it "adds the expiry date to cached entries" do
        cache_repository.expect(:add_forecasts, nil, [[entry_to_cache1, entry_to_cache2]])

        Timecop.freeze(Time.now) do
          subject

          assert_equal Time.now.at_end_of_day, entry_to_cache1.expiry_date
        end
      end
    end
  end
end
