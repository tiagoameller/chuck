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
    kind { 1 }
    question { 'MyString' }
    answer_count { 1 }
  end
end
