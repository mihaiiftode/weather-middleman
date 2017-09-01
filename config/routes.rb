Rails.application.routes.draw do
  scope "/weather" do
    get "summary" => "summary#fetch"
  end
end
