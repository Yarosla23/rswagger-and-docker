class School < ApplicationRecord
  has_many :school_classes, dependent: :destroy
  has_many :students, dependent: :destroy

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 100 },
    uniqueness: { case_sensitive: false, message: "школа с таким названием уже существует" }
end
