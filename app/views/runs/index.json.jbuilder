json.array!(@runs) do |run|
  json.extract! run, :name, :attempts, :offset, :size
  json.url run_url(run, format: :json)
end
