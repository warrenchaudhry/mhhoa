require 'rails_helper'

RSpec.describe MonthlyDuePayment, type: :model do
  let!(:monthly_due_rate) { create(:monthly_due_rate, amount: 400) }
  let!(:homeowner) { create(:homeowner) }
  let!(:monthly_due_payment) { create(:monthly_due_payment, amount: 400, monthly_due_rate: monthly_due_rate, homeowner: homeowner) }

  subject { monthly_due_payment }

  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount) }

  it 'should belong to homeowner' do
    expect(subject.homeowner).to eq(homeowner)
  end

  it 'should validate presence of amount' do
    subject.update(amount: nil)
    expect(subject.errors.full_messages).to include('Amount can\'t be blank')
  end

  describe 'validations' do
    it 'should not save if amount is less than or equal to zero' do
      subject.update(amount: 0)
      expect(subject.errors.full_messages).to include('Amount must be greater than 0')
    end

    it 'should not save if amount is greater than imposed monthly rate' do
      subject.reload.update(amount: 500)
      expect(subject.errors.full_messages).to include('Amount should not be greater than 400')
    end

    it 'should not save if paid at is in future' do
      subject.reload.update(paid_at: Date.tomorrow)
      expect(subject.errors.full_messages).to include('Paid at should not be in future')
    end
  end
end
