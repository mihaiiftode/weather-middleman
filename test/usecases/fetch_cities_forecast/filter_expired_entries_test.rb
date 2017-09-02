require "test_helper"

describe FetchCitiesForecast::FilterExpiredEntries do
  describe "perform" do
    let(:cached_entry1) {
      Forecast.new({
                       :city_id => 2618425,
                       :type => ForecastType::TEN_DAYS,
                       :expiry_date => "\"\"",
                       :temperatures => Hash.new
                   })
    }
    let(:cached_entry2) {
      Forecast.new({
                       :city_id => 2950096,
                       :type => ForecastType::TEN_DAYS,
                       :expiry_date => "\"\"",
                       :temperatures => Hash.new
                   })
    }

    let(:forecasts) { [cached_entry1, cached_entry2] }
    let(:context) { { forecasts: forecasts, unknown_forecasts: [] } }

    subject { FetchCitiesForecast::FilterExpiredEntries.perform(context) }

    it "remove the expired forecast from the forecasts and move it to unknown forecasts" do

      Timecop.freeze(Time.new(2017, 3, 3, 23, 23, 23)) do
        cached_entry1.expiry_date = Time.now.at_end_of_day.to_json
        cached_entry2.expiry_date = (Time.now.at_end_of_day - 1.day).to_json

        result = subject

        assert_equal 1, result.forecasts.count
        assert_equal cached_entry1, result.forecasts[0]
        assert_equal 1, result.unknown_forecasts.count
        assert_equal cached_entry2, result.unknown_forecasts[0]
      end
    end
  end
end
