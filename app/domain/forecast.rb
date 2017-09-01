class Forecast
  attr_accessor :city_id, :type, :expiry_date, :temperatures

  def initialize(params = {})
    params ||= {}
    params.each { |key, value| public_send("#{key}=", value) }
  end

  def key
    { :city_id => @city_id, :type => @type }.to_json
  end

  def value
    { :expiry_date => @expiry_date, :temperatures => @temperatures }.to_json
  end
end
