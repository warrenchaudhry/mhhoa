class Homeowner < ApplicationRecord
  belongs_to :street
  has_many :monthly_due_payments, dependent: :destroy
  validates :firstname, :lastname, :street, presence: true

  def full_name
    [lastname, firstname].join(', ')
  end
end
