require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @location_id = "667268"
    Redis.new.flushdb
  end

  test "should return an temperature for the next day for the given ids and the threshold" do
    VCR.use_cassette("LocationsController integration test") do
      get "/weather/locations/#{@location_id}"
    end

    result = JSON.parse(@response.body, symbolize_names: true)
    assert_response :success
    assert_equal "667268", result[:city_id]
    assert_equal 10, result[:temperatures].count
  end
end
