# == Schema Information
#
# Table name: companies
#
#  id          :uuid             not null, primary key
#  name        :string
#  nick        :string
#  vat_number  :string
#  address_one :string
#  address_two :string
#  city        :string
#  zip_code    :string
#  state       :string
#  country     :string           default("ES")
#  email       :string
#  website     :string
#  phone       :string
#  admin_name  :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_nick        (nick) UNIQUE
#  index_companies_on_vat_number  (vat_number) UNIQUE
#

FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    vat_number { 'ESB07079999' }
    admin_name { 'Juan Pons' }
    address_one { '72101 Wintheiser Spring' }
    address_two { 'Suite 260' }
    zip_code { '58517' }
    city { 'Alaior' }
    state { 'IB' }
    country { 'ES' }
    email { Faker::Internet.email }
    website { Faker::Internet.url(host: 'example.com') }
    phone { Faker::PhoneNumber.phone_number }
    factory :company_with_users do
      after(:create) do |company|
        company.users.create(
          [
            attributes_for(:user, name: 'First User', vat_number: '41495761N'),
            attributes_for(:user, name: 'Second User', vat_number: '41497291R')
          ]
        )
      end
    end
  end
end
