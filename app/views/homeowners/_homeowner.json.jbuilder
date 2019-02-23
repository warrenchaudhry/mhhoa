json.extract! homeowner, :id, :firstname, :mi, :lastname, :street_id, :active, :created_at, :updated_at
json.url homeowner_url(homeowner, format: :json)
