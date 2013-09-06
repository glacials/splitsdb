json.array!(@divisions) do |division|
  json.extract! division, :game_id, :category_id
  json.url division_url(division, format: :json)
end
