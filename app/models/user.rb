# == Schema Information
#
# Table name: users
#
#  id                        :uuid             not null, primary key
#  email                     :string
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  company_id                :uuid
#  name                      :string
#  first_name                :string
#  last_name                 :string
#  username                  :string
#  loginname                 :string
#  phone                     :string
#  comment                   :text
#  dark_theme                :boolean          default(FALSE)
#  role                      :integer          default("employee")
#  default_admin             :boolean          default(FALSE)
#  active                    :boolean          default(TRUE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_company_id_and_email     (company_id,email) UNIQUE
#  index_users_on_company_id_and_username  (company_id,username) UNIQUE
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_loginname                (loginname) UNIQUE
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'
  include Gravtastic
  include UserReports
  gravtastic :email, default: 'mm'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         authentication_keys: [:login]

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  attr_writer :login

  has_person_name

  belongs_to :company
  audited associated_with: :company, except: %w(sign_in_count last_sign_in_at last_sign_in_ip current_sign_in_at current_sign_in_ip password)
  has_many :visit_users, dependent: :destroy

  enum role: { guest: 0, employee: 2, office: 4, admin: 6, super_admin: 9 }

  validates :company, presence: true
  validates :name, length: { minimum: 3 }
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            uniqueness: true,
            allow_blank: true,
            unless: :admin?
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            uniqueness: true,
            if: :admin?
  validates :username, length: { minimum: 3 }
  validates :username, uniqueness: { scope: [:company_id], case_sensitive: false }, on: :update
  validates :role, inclusion: { in: User.roles.keys }

  scope :of_company, ->(company) { company.users }
  scope :visible, -> { where('role < ?', User.roles[:super_admin]) }
  scope :active, -> { where(active: true) }

  before_save do
    self.email = nil if email.blank?
    self.email = email&.downcase
  end

  before_validation do |rec|
    if rec.name.present? && rec.username.blank?
      rec.username =
        if rec.name.last.blank?
          rec.name.first.split.first.downcase
        else
          rec.name.mentionable
        end
    end
    rec.username = rec.username.parameterize if rec.username.present?
    rec.username&.downcase!
    rec.loginname = "#{rec.company.nick}.#{rec.username}" if rec.company.present? && rec.username.present?
    rec.loginname&.downcase!
    if new_record? && rec.company.present?
      i = 1
      loop do
        break unless User.exists?(loginname: rec.loginname)

        rec.username += i.to_s
        i += 1
        rec.loginname = "#{rec.company.nick}.#{rec.username}"
      end
    end
    admin_privileges_true(rec) if rec.at_least_admin?
  end

  def full_name
    "#{name} (#{loginname})"
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    # deny login to inactive users
    conditions['active'] = true
    result =
      if login
        where(conditions.to_h).where(['lower(loginname) = :value OR lower(email) = :value', { value: login.downcase }])
      elsif conditions.key?(:loginname) || conditions.key?(:email)
        where(conditions.to_h)
      end
    result&.first
  end

  def login
    # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    # allow login with company.username or email. Remember: loginname = #{company.nick}.#{username}
    @login || loginname || email
  end

  def at_least_employee?
    User.roles[role] >= User.roles[:employee]
  end

  def at_least_office?
    User.roles[role] >= User.roles[:office]
  end

  def at_least_admin?
    User.roles[role] >= User.roles[:admin]
  end

  def inactive?
    !active?
  end

  def self.from_token_payload(payload)
    # logger.info('User#from_token_payload')
    # return nil if valid user and valid token, but admin has removed api_acces to that user
    user = find(payload['sub'])
    return user if user.api_access?
  end

  private

  # https://www.rubydoc.info/github/plataformatec/devise/master/Devise%2FModels%2FValidatable:email_required%3F
  def email_required?
    false
  end

  def admin_privileges_true(rec)
    # sample
  end
end
