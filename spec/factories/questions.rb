# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  kind         :integer
#  question     :string
#  answer_count :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :question do
    answer_count { 1 }
    factory :question_by_category do
      kind { Question.kinds[:category] }
      question { 'a_category' }
    end
    factory :question_by_word do
      kind { Question.kinds[:word] }
      question { 'a_word' }
    end
    factory :question_by_random do
      kind { Question.kinds[:random] }
      question { nil }
    end
  end
end
