require "test_helper"

describe Forecast do
  let(:params) {}
  let(:instance) { Forecast.new(params) }

  describe "initialize" do
    subject { instance }

    describe "params contains attributes" do
      let(:params) { { city_id: "123" } }

      it "assigns the given attribute to the indicated attribute" do
        result = subject

        assert_equal "123", result.city_id
      end
    end
  end

  describe "key" do
    let(:params) { { city_id: "123", type: ForecastType::TEN_DAYS } }
    let(:instance) { Forecast.new(params) }
    let(:expected_key) { "{\"city_id\":\"123\",\"type\":\"TEN_DAYS\"}" }
    subject { instance.key }

    it "should return a array with key value" do
      result = subject

      assert_equal expected_key, result
    end
  end

  describe "value" do
    let(:params) { { expiry_date: "123", temperatures: "{}" } }
    let(:expected_value) { "{\"expiry_date\":\"123\",\"temperatures\":\"{}\"}" }
    subject { instance.value }

    it "should return a array with value" do
      result = subject

      assert_equal expected_value, result
    end
  end

  describe "value from json" do
    let(:json) { "{\"expiry_date\":\"123\",\"temperatures\":\"{}\"}" }

    subject { instance.value_from_json(json) }

    it "should return a array with value" do
      subject

      assert_equal "123", instance.expiry_date
      assert_equal "{}", instance.temperatures
    end
  end

  describe "response" do
    let(:params) { { city_id: "123", temperatures: 20 } }

    subject { instance.response }

    it "should return a json to be used as an response" do
      result = subject

      assert_equal "{\"city_id\":\"123\",\"temperatures\":20}", result
    end
  end
end
