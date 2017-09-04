Rails.application.routes.draw do
  scope "/weather" do
    get "summary" => "summary#fetch"
    get "locations/:location_id" => "locations#fetch"
  end
end
