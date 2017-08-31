require "test_helper"

describe ForecastMan do
  let(:units) { "metric" }
  let(:instance) { ForecastMan.new(units) }

  describe "temperature_ten_days" do
    let(:id) { 667268 }

    subject { instance.temperature_ten_days(id) }

    it "returns temperature forecast data for the next day for the id's" do
      result = nil
      VCR.use_cassette("OpenWeather - temperature forecast") do
        result = subject
      end

      assert_equal "Sibiu", result["city"]["name"]
      assert_equal 10, result["cnt"]
      assert_equal 14, result["list"][0]["temp"]["day"]
      assert_equal 17.42, result["list"][9]["temp"]["day"]
    end
  end

  describe "next_day_temperatures" do
    let(:ids) { [2618425, 2950096, 667268] }

    subject { instance.next_day_temperatures(ids) }

    it "returns temperature for the next day of the selected id" do
      result = nil
      VCR.use_cassette("OpenWeather - temperature next weather") do
        result = subject
      end

      assert_equal "Copenhagen", result[0]["city"]["name"]
      assert_equal 1, result[0]["cnt"]
      assert_equal 13.61, result[0]["list"][0]["temp"]["day"]
    end
  end
end
