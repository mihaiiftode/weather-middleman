require "test_helper"

describe FetchLocationForecast::FetchExistingEntry do
  describe "perform" do
    let(:city_id) { nil }
    let(:cache_repository) { nil }
    let(:context) { { city_id: city_id, cache_repository: cache_repository } }

    subject { FetchLocationForecast::FetchExistingEntry.perform(context) }

    describe "city id is empty" do
      it "adds no forecasts to the context" do
        result = subject

        assert_nil result.forecast
      end
    end

    describe "city id is not empty" do
      let(:cache_repository) { MiniTest::Mock.new }
      let(:city_id) { 2_618_425 }
      let(:cached_entry1) do
        Forecast.new(
          city_id: 2_618_425,
          type: ForecastType::TEN_DAYS,
          expiry_date: "123",
          temperatures: {}
        )
      end

      it "tries to get the forecast from the cache" do
        cache_repository.expect(:get_forecast, { expiry_date: "123", temperatures: {} }, [String])
        context[:cache_repository] = cache_repository

        subject

        cache_repository.verify
      end

      describe "trying to fetch forecast works" do
        it "brings the correct info from the cache" do
          cache_repository.expect(:get_forecast, { expiry_date: "123", temperatures: {} }, [String])

          result = subject

          assert_equal cached_entry1.city_id, result.forecast.city_id
          assert_equal cached_entry1.expiry_date, result.forecast.expiry_date
        end
      end
    end
  end
end
