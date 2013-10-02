json.array!(@splits) do |split|
  json.extract! split, :name, :run_id, :old, :best_run, :best_segment
  json.url split_url(split, format: :json)
end
