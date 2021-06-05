FactoryBot.define do
  factory :question do
    kind { 1 }
    question { 'MyString' }
    answer_count { 1 }
  end
end
