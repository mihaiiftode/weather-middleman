# Fetches summary of locations
class SummaryController < ApplicationController

  # rescue_from Exception, with: :invalid_params
  ALLOWED_PARAMS = [:units, :locations, :threshold].freeze

  def fetch
    ensure_params
    ids = params[:locations].split(',')
    threshold = Integer(params[:threshold])
    response = FetchCitiesForecast::Base.perform(units: params[:units], city_ids: ids, threshold: threshold).response
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
