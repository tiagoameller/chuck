class AppAuditPresenter < ApplicationPresenter
  def auditable_full_name
    auditable_class = @model.auditable_type&.constantize
    auditable = auditable_class.find_by id: @model.auditable_id
    result =
      if auditable
        find_name(@model.auditable)
      elsif associated
        find_name(@model.associated)
      end
    if result
      url = "#{@model.auditable_type&.camelize&.underscore}_path"
      if @view.respond_to?(url) && @model&.auditable
        @view.link_to(
          result,
          @view.send(url, @model.auditable),
          remote: true
        )
      else
        result
      end
    else
      I18n.t('common.not_found')
    end
  rescue NameError
    I18n.t('common.not_found')
  end

  def auditable_type_i18n
    @model.auditable_type.constantize.model_name.human
  end

  def formatted_action
    [
      auditable_type_i18n,
      I18n.t("actions.#{@model.action}"),
      I18n.t('common.by'),
      (@model&.user&.loginname || I18n.t('common.not_found'))
    ].join ' '
  end

  def formatted_when
    @view.format_date_time(@model.created_at)
  end

  def time_ago
    @view.time_ago_in_words(@model.created_at)
  end

  def action_class
    case @model.action.to_s
    when 'create'
      'success'
    when 'update'
      'warning'
    when 'destroy'
      'danger'
    else
      'info'
    end
  end

  def audited_changes_translated
    {}.tap do |result|
      @model.audited_changes.each do |k, v|
        if k.to_s.end_with? '_id'
          key = k.gsub('_id', '')
          result[I18n.t("attributes.#{key}")] =
            if v.is_a? Array
              v.map { |item| find_relation(key, item) }
            else
              find_relation(key, v)
            end
        else
          result[I18n.t("attributes.#{k}")] = translate_nil(v)
        end
      end
    end.sort.to_h
  end

  private

  def find_relation(key, value)
    relation_class =
      if %w(owner manager).include? key
        Contact
      elsif key.present?
        key.titleize.constantize
      end
    find_name(relation_class&.find_by(id: value)) || translate_nil(value)
  rescue NameError
    translate_nil(value)
  end

  def find_name(auditable)
    return translate_nil(nil) unless auditable

    result = nil
    %i(full_name name description).each do |key|
      if auditable.respond_to? key
        result = auditable.send key
        break
      end
    end
    result || auditable.id
  end

  def translate_nil(value)
    value || '-'
  end
end
