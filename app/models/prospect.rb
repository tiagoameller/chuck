# == Schema Information
#
# Table name: prospects
#
#  id             :uuid             not null, primary key
#  company_name   :string
#  location       :string
#  employee_count :integer
#  username       :string
#  email          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  processed      :boolean          default(FALSE)
#  vat_number     :string
#

class Prospect < ApplicationRecord
  self.implicit_order_column = 'created_at'
  # do not include
  # include VatNumberable

  validates :company_name, length: { minimum: 6, maximum: 60 }
  validates :vat_number, presence: true
  validates :location, presence: true
  validates :username, length: { minimum: 3 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save { self.email = email&.downcase }
end
