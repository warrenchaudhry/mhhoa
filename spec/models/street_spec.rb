require 'rails_helper'

RSpec.describe Street, type: :model do
  it { should validate_presence_of(:name) }
end
