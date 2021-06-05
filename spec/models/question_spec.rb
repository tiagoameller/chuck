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
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should define_enum_for(:kind) }
end
