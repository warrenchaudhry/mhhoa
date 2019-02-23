class Street < ApplicationRecord
  has_many :homeowners, dependent: :nullify
  validates :name, presence: true

  def to_s
    name
  end
end
