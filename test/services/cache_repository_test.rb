require "test_helper"

describe CacheRepository do
  let(:redis_client) { MiniTest::Mock.new }
  let(:instance) { CacheRepository.new(redis_client) }
  let(:cached_entry1) do
    Forecast.new(
      city_id: 2_618_425,
      type: ForecastType::TEN_DAYS,
      expiry_date: "123",
      temperatures: {}
    )
  end

  describe "add_forecasts" do
    let(:forecasts) { [cached_entry1] }

    subject { instance.add_forecasts(forecasts) }

    it "tries to cache the forecast" do
      def redis_client.pipelined(*)
        yield
      end

      redis_client.expect(:set, nil, [cached_entry1.key, cached_entry1.value])

      subject

      redis_client.verify
    end
  end

  describe "add_forecast" do
    let(:forecast) { cached_entry1 }

    subject { instance.add_forecast(forecast) }

    it "tries to cache the forecast" do

      redis_client.expect(:set, nil, [cached_entry1.key, cached_entry1.value])

      subject

      redis_client.verify
    end
  end

  describe "get_address" do
    let(:key) { cached_entry1.key }

    subject { instance.get_forecast(key) }

    it "tries to get the stored value" do
      redis_client.expect(:get, "{}", [key])

      subject

      redis_client.verify
    end

    describe "a value is stored for the given key" do
      it "should return a json containing the stored value" do
        redis_client.expect(:get, "{ \"expiry_date\": \"123\", \"temperatures\":\"{}\" }", [key])
        assert_equal({ expiry_date: "123", temperatures: "{}" }, subject)
      end
    end

    describe "no value is stored for the given key" do
      it "should return a json containing the stored value" do
        redis_client.expect(:get, nil, [key])
        assert_nil subject
      end
    end
  end
end
