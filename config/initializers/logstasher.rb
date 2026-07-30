if LogStasher.enabled?
  LogStasher.add_custom_fields do |fields|
    fields[:type] = "formulaire_qf"
  end
end
