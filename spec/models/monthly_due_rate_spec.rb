require 'rails_helper'

RSpec.describe MonthlyDueRate, type: :model do
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:start_date) }
end
