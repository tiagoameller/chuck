class AuditsController < ApplicationController
  def last
    @audits = (
      if current_user.super_admin?
        AppAudit.all
      elsif current_user.admin?
        AppAudit.company_activity(current_user.company)
      else
        AppAudit.user_activity(current_user)
      end
    )
              .order(created_at: :desc)
              .limit(params[:limit] || 24)
  end
end
