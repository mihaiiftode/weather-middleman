require 'test_helper'

class SummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get fetch" do
    get summary_fetch_url
    assert_response :success
  end

end
