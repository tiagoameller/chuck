FactoryBot.define do
  factory :answer do
    question { nil }
    categories { 'MyString' }
    url { 'MyString' }
    value { 'MyText' }
  end
end
