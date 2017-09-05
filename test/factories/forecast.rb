FactoryGirl.define do
  factory :forecast, class: "Forecast" do
    skip_create

    city_id { Faker::Number.positive.to_i.to_s }
    type { ForecastType::TEN_DAYS }
    expiry_date { Faker::Time.between(Time.now - 1, Time.now) }
    temperatures { "{ \"temperature\": 20 }" }
  end
end
