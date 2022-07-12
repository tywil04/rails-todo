WebAuthn.configure do |config|
    config.origin = "http://localhost:3000"
    config.rp_name = "Rails Todo"
    config.rp_id = "localhost"
end