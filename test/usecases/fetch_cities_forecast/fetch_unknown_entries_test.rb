require "test_helper"

describe FetchCitiesForecast::FetchUnknownEntries do
  describe "perform" do
    let(:forecast_man) { Minitest::Mock.new }
    let(:forecasts) { [entry1] }
    let(:unknown_forecasts) { [entry2] }
    let(:entry1) do
      Forecast.new(
        city_id: 2_618_425,
        type: ForecastType::NEXT_DAY,
        expiry_date: "\"\"",
        temperatures: "{ \"temperature\": 20 }"
      )
    end
    let(:entry2) do
      Forecast.new(
        city_id: 2_950_096,
        type: ForecastType::NEXT_DAY,
        expiry_date: "\"\"",
        temperatures: "{}"
      )
    end
    let(:context) { { forecast_man: forecast_man, forecasts: forecasts, unknown_forecasts: unknown_forecasts } }

    subject { FetchCitiesForecast::FetchUnknownEntries.perform(context) }

    describe "unknown forecasts have an item present" do
      before do
        forecast_man.expect(:next_day_temperature, { temperature: 22 }.to_json, [entry2.city_id])
      end

      it "should be added to the forecast with temperature" do
        result = subject

        assert_equal 2, result.forecasts.count
        assert_equal({ temperature: 22 }.to_json, result.forecasts[1].temperatures)
      end
    end
  end
end
