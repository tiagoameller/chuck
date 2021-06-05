# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  question_id :bigint           not null
#  categories  :string
#  url         :string
#  value       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
FactoryBot.define do
  factory :answer do
    question { nil }
    categories { 'MyString' }
    url { 'MyString' }
    value { 'MyText' }
  end
end
