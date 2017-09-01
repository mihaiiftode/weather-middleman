require "test_helper"

class SummaryControllerTest < ActionDispatch::IntegrationTest
  def setup
    @params = { locations: "2618425,2950096,667268", units: "metric", threshold: "10" }
    Redis.new.flushdb
  end

  test "should return an temperature for the next day for the given ids and the threshold" do
    VCR.use_cassette("SummaryController integration test") do
      get summary_url, params: @params
    end

    result = JSON.parse(@response.body, symbolize_names: true)
    assert_response :success
    assert_equal 3, result.count
    assert_equal "2618425", result[0][:city_id]
    assert_equal 11.78, result[0][:temperatures]
  end
end
