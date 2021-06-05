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

class Company < ApplicationRecord
  self.implicit_order_column = 'created_at'
  include MyAddressable
  include VatNumberable

  has_many :users, dependent: :destroy

  has_associated_audits

  enum paid_plan: { free: 0, month: 1, year: 2, two_years: 3, life: 4 }

  validates :name, length: { minimum: 6, maximum: 60 }
  validates :nick, length: { minimum: 3 }, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w(http https)) }, allow_blank: true
  validates :vat_number, uniqueness: true
  validates :admin_name, length: { minimum: 3 }

  before_validation :create_nick

  before_save { self.email = email&.downcase }

  def full_name
    "#{name} (#{nick})"
  end

  def plan_name
    "#{paid_plan_i18n}. #{paid_user_count} #{User.model_name.human(count: paid_user_count)}".titleize
  end

  def can_add_users?
    User.active_users(self).count < paid_user_count
  end

  # TODO: translate
  # TODO: TEST
  def self.calc_price(plan, users, helpers)
    case plan
    when 'free'
      'Gratis'
    when 'month'
      "#{helpers.number_to_currency(users)} cada mes"
    when 'year'
      "#{helpers.number_to_currency(users * 0.9 * 12)} cada año"
    when 'two_years'
      "#{helpers.number_to_currency(users * 0.8 * 24)} cada dos años"
    when 'life'
      "#{helpers.number_to_currency(users * 37.5)} pago único"
    end
  end

  private

  def create_nick
    if name.present? && nick.blank?
      self.nick =
        if name.index(' ').nil?
          name.parameterize
        else
          name.parameterize.split('-').map { |a| a[0..2] }.join[0..5]
        end
      self.nick += '1' while nick.size < 3
    end
    self.nick&.downcase!
    return unless new_record? && name.present?

    i = 1
    loop do
      break unless Company.find_by(nick: self.nick)

      self.nick += i.to_s
      i += 1
    end
  end
end
