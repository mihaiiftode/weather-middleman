require "test_helper"

describe FetchCitiesForecast::MapTemperatureToResponse do
  describe "perform" do
    let (:forecast) { Forecast.new(
        city_id: 2_618_425,
        type: ForecastType::TEN_DAYS,
        expiry_date: "123",
        temperatures: '{
               "city":{
                  "id":2618425,
                  "name":"Copenhagen",
                  "coord":{
                     "lon":12.5655,
                     "lat":55.6759
                  },
                  "country":"DK",
                  "population":0
               },
               "cod":"200",
               "message":0.0356218,
               "cnt":1,
               "list":[
                  {
                     "dt":1504350000,
                     "temp":{
                        "day":9.58,
                        "min":9.58,
                        "max":9.69,
                        "night":9.69,
                        "eve":9.58,
                        "morn":9.58
                     },
                     "pressure":1029.95,
                     "humidity":100,
                     "weather":[
                        {
                           "id":803,
                           "main":"Clouds",
                           "description":"broken         clouds",
                           "icon":"04n"
                        }
                     ],
                     "speed":2.82,
                     "deg":327,
                     "clouds":56
                  }
               ]
            }'
    ) }
    let(:threshold) { 0 }
    let(:context) { { forecasts: [forecast], threshold: threshold } }

    subject { FetchCitiesForecast::MapTemperatureToResponse.perform(context) }

    it "should parse the temperature to next day temperature" do
      result = subject

      assert_equal 9.58, result.forecasts[0].temperatures
    end

    describe "threshold is bigger than the temperatures" do
      let(:threshold) { 20 }

      it "should filter the forecasts" do
        result = subject

        assert_equal 0, result.forecasts.count
      end
    end
  end
end
