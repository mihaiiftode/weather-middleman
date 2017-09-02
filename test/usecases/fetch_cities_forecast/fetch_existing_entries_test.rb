require "test_helper"

describe FetchCitiesForecast::FetchExistingEntries do
  describe "perform" do
    let(:city_ids) { [] }
    let(:cache_repository) { nil }
    let(:context) { { city_ids: city_ids, cache_repository: cache_repository } }

    subject { FetchCitiesForecast::FetchExistingEntries.perform(context) }

    describe "city ids are empty" do
      it "adds an empty array of forecasts to the context" do
        result = subject

        assert_equal [], result.forecasts
      end

      it "adds an empty array of unknown forecasts to the context" do
        result = subject

        assert_equal [], result.unknown_forecasts
      end
    end

    describe "city ids are not empty" do
      let(:cache_repository) { MiniTest::Mock.new }
      let(:city_ids) { [2_618_425, 2_950_096] }
      let(:cached_entry1) do
        Forecast.new(
          city_id: 2_618_425,
          type: ForecastType::TEN_DAYS,
          expiry_date: "123",
          temperatures: {}
        )
      end
      let(:cached_entry2) do
        Forecast.new(
          city_id: 2_950_096,
          type: ForecastType::TEN_DAYS,
          expiry_date: "123",
          temperatures: {}
        )
      end

      it "tries to get the forecast from the cache" do
        cache_repository.expect(:get_forecast, cached_entry1.value, [String])
        cache_repository.expect(:get_forecast, cached_entry2.value, [String])
        context[:cache_repository] = cache_repository

        subject

        cache_repository.verify
      end

      describe "trying to fetch forecasts works" do
        it "brings the correct info from the cache" do
          cache_repository.expect(:get_forecast, cached_entry1.value, [String])
          cache_repository.expect(:get_forecast, cached_entry2.value, [String])

          result = subject

          assert_equal cached_entry1.city_id, result.forecasts[0].city_id
          assert_equal cached_entry1.expiry_date, result.forecasts[0].expiry_date
          assert_equal cached_entry2.city_id, result.forecasts[1].city_id
          assert_equal cached_entry2.expiry_date, result.forecasts[1].expiry_date
        end
      end
    end
  end
end
