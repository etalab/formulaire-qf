Around("@protection_contre_la_falsification") do |_scenario, block|
  ActionController::Base.allow_forgery_protection = true
  block.call
ensure
  ActionController::Base.allow_forgery_protection = false
end
