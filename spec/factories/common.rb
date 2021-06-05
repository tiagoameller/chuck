FactoryBot.define do
  # common attributes
  sequence(:email) { |i| "n#{i}@fakemail.com" }
  sequence(:phone) { |i| (600_000_000 + i).to_s }
end
