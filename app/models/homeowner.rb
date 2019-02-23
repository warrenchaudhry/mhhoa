class Homeowner < ApplicationRecord
  belongs_to :street
  validates :firstname, :lastname, :street, presence: true

  def full_name
    [lastname, firstname].join(', ')
  end
end
