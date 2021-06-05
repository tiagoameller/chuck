require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
end
