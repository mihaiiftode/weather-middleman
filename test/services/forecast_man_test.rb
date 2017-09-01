require "test_helper"

describe ForecastMan do
  let(:units) { "metric" }
  let(:instance) { ForecastMan.new(units) }

  describe "temperature_ten_days" do
    let(:id) { 667_268 }

    subject { instance.temperature_ten_days(id) }

    it "returns temperature forecast data for the next day for the id" do
      result = nil
      VCR.use_cassette("OpenWeather - one location ten days") do
        result = subject
      end

      assert_equal "Sibiu", result["city"]["name"]
      assert_equal 10, result["cnt"]
      assert_equal 23, result["list"][0]["temp"]["day"]
      assert_equal 21.54, result["list"][9]["temp"]["day"]
    end
  end

  describe "next_day_temperature" do
    let(:id) { 2_618_425 }

    subject { instance.next_day_temperature(id) }

    it "returns temperature for the next day of the selected id" do
      result = nil
      VCR.use_cassette("OpenWeather - multiple locations one day") do
        result = subject
      end

      assert_equal "Copenhagen", result["city"]["name"]
      assert_equal 1, result["cnt"]
      assert_equal 9.58, result["list"][0]["temp"]["day"]
    end
  end
end
