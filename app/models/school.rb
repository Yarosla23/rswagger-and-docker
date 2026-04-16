class School < ApplicationRecord
  has_many :school_classes, dependent: :destroy, inverse_of: :school
  has_many :students, dependent: :destroy, inverse_of: :school

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 100 },
    uniqueness: { case_sensitive: false, message: "школа с таким названием уже существует" }
end
