json.array!(@tickets) do |ticket|
  json.extract! ticket, :ticket_type, :uuid, :user_id
  json.url ticket_url(ticket, format: :json)
end
