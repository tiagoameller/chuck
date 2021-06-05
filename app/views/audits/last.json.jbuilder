json.audits do
  json.set! :literals do
    json.set! :no_actitiy, I18n.t('audit.no_activity')
  end

  json.data @audits.each do |model|
    present(model) do |audit|
      json.auditable_full_name audit.auditable_full_name
      json.auditable_type audit.auditable_type_i18n
      json.action audit.formatted_action
      json.action_class audit.action_class
      json.when audit.formatted_when
      json.time_ago audit.time_ago
      json.timestamp audit.created_at
      json.audited_changes audit.audited_changes_translated
    end
  end
end
