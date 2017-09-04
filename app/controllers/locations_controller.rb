class LocationsController < ApplicationController
  rescue_from Exception, with: :invalid_params
  ALLOWED_PARAMS = %i[location_id].freeze

  def fetch
    ensure_params
    city_id = params[:location_id]
    response = FetchLocationForecast::Base.perform(city_id: city_id).response
    render json: response, status: :ok
  end

  private

  def ensure_params
    raise unless ALLOWED_PARAMS.all?(&params.method(:key?))
  end

  def invalid_params(_)
    render json: { error: "Params are invalid" }, status: :bad_request
  end
end
