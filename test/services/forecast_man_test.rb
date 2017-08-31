require "test_helper"

describe ForecastMan do
  let(:units) { "metric" }
  let(:instance) { ForecastMan.new(units) }

  describe "temperatures" do
    let(:ids) { [2618425, 2950096, 667268] }

    subject { instance.temperatures(ids) }

    it "returns temperature forecast data for the next 10 days for the id's" do
      result = nil
      VCR.use_cassette("OpenWeather - temperature forecast") do
        result = subject
      end

      assert_equal "Copenhagen", result[0]["city"]["name"]
      assert_equal 10, result[0]["cnt"]
      assert_equal 14.2, result[0]["list"][0]["temp"]["day"]
      assert_equal 22.44, result[0]["list"][9]["temp"]["day"]
    end
  end

  describe "next_day_temperature" do
    let(:id) { 667268 }

    subject { instance.next_day_temperature(id) }

    it "returns temperature for the next day of the selected id" do
      result = nil
      VCR.use_cassette("OpenWeather - temperature next weather") do
        result = subject
      end

      assert_equal "Sibiu", result["city"]["name"]
      assert_equal 1, result["cnt"]
      assert_equal 16, result["list"][0]["temp"]["day"]
    end
  end
end
