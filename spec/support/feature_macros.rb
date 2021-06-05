# https://stackoverflow.com/questions/32628093/using-devise-in-rspec-feature-tests
module FeatureMacros
  include Warden::Test::Helpers
  def login_user(options = {})
    company = Company.first
    attr = FactoryBot.attributes_for(:user)
    attr[:role] = options[:role] || :basic
    user = company.users.create!(attr)
    Warden.test_mode!
    login_as(user, scope: :user)
    user
  end

  def login_admin(options = {})
    login_user(options.merge(role: :admin))
  end

  def logout_user
    logout(:user)
    Warden.test_reset!
  end
end
