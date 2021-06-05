# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  company_id             :uuid
#  name                   :string
#  first_name             :string
#  last_name              :string
#  username               :string
#  loginname              :string
#  comment                :text
#  role                   :integer          default("basic")
#  default_admin          :boolean          default(FALSE)
#  active                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_company_id_and_email     (company_id,email) UNIQUE
#  index_users_on_company_id_and_username  (company_id,username) UNIQUE
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_loginname                (loginname) UNIQUE
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    name { 'Juan Pons' }
    password { '123456' }
    email { 'un@email.com' }
    phone
    role { :admin }
    factory :employee do
      name { 'Pepe Pons' }
      email { generate :email }
      role { :employee }
    end
  end
end
