require 'rails_helper'

RSpec.describe Employee, type: :model do
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
end
