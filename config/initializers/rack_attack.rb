class Rack::Attack
  # Throttle login attempts by IP
  throttle('logins/ip', limit: 20, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api/v1/auth')
  end

  # Basic throttle on general API usage
  throttle('api/general', limit: 300, period: 5.minutes) do |req|
    req.ip if req.path.start_with?('/api/')
  end
end

Rails.application.config.middleware.use Rack::Attack



