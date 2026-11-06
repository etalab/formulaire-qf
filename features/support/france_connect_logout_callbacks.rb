module FranceConnectLogoutCallbacks
  def self.paths
    @paths ||= []
  end
end

ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*, payload|
  FranceConnectLogoutCallbacks.paths << payload[:path] if payload[:path].start_with?("/logout-callback")
end

Before { FranceConnectLogoutCallbacks.paths.clear }
