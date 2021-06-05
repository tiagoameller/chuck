# == Schema Information
#
# Table name: audits
#
#  id              :bigint           not null, primary key
#  auditable_id    :uuid
#  auditable_type  :string
#  associated_id   :uuid
#  associated_type :string
#  user_id         :uuid
#  user_type       :string
#  username        :string
#  action          :string
#  audited_changes :jsonb
#  version         :integer          default(0)
#  comment         :string
#  remote_address  :string
#  request_uuid    :string
#  created_at      :datetime
#
# Indexes
#
#  associated_index              (associated_type,associated_id)
#  auditable_index               (auditable_type,auditable_id,version)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#
class AppAudit < Audited::Audit
  # custom audit to access adudits by user and company
  scope :user_activity, ->(user) { where(user_id: user.id) }
  scope :company_activity, ->(company) { where("associated_type = 'Company' and associated_id = ?", company.id) }
end
