require "test_helper"

describe FetchLocationForecast::FetchAndCacheEntry do
  describe "perform" do
    let(:forecast_man) { Minitest::Mock.new }
    let(:cache_repository) { Minitest::Mock.new }
    let(:forecast) { entry1 }
    let(:city_id) { 2_618_425 }
    let(:entry1) do
      Forecast.new(
        city_id: 2_618_425,
        type: ForecastType::NEXT_DAY,
        expiry_date: "",
        temperatures: "{ \"temperature\": 20 }"
      )
    end

    let(:context) { { forecast_man: forecast_man, cache_repository: cache_repository, forecast: forecast, city_id: city_id } }

    subject { FetchLocationForecast::FetchAndCacheEntry.perform(context) }

    describe "forecast is not expired" do
      it "forecast should not change" do
        Timecop.freeze(Time.now) do
          entry1.expiry_date = Time.now.at_end_of_day.to_s

          result = subject

          assert_equal entry1, result.forecast
        end
      end
    end

    describe "forecast is expired" do
      before do
        forecast_man.expect(:temperature_ten_days, [temperature: 22].to_json, [entry1.city_id])
        cache_repository.expect(:add_forecast, nil, [entry1])
      end

      it "should fetch the new forecast from forecast man and cache it" do
        result = subject

        assert_equal([temperature: 22].to_json, result.forecast.temperatures)
        cache_repository.verify
      end
    end
  end
end
