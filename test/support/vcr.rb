VCR.configure do |c|
  c.cassette_library_dir = "test/cassetes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = false
end
