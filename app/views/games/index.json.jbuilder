json.array!(@games) do |game|
  json.extract! game, :name, :cover
  json.url game_url(game, format: :json)
end
