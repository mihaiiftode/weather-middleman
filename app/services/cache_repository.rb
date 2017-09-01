class CacheRepository
  def initialize(redis_client = nil)
    @redis_client = redis_client || Redis.new
  end

  def add_forecasts(new_forecasts)
    @redis_client.pipelined { new_forecasts.each(&method(:add_forecast!)) }
  rescue Redis::BaseError
    Rails.logger.error("Redis is down, can't update keys")
  end

  def get_forecast(forecast_key)
    stored_value = @redis_client.get(forecast_key)
    JSON.parse(stored_value, symbolize_names: true) if stored_value.present?
  rescue Redis::BaseError
    Rails.logger.error("Error while fetching stored value")
  end

  private

  def add_forecast(new_forecast)
    @redis_client.set(new_forecast.key, new_forecast.value)
  end
end
