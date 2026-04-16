class SchoolClass < ApplicationRecord
  LETTER_FORMAT = /\A[А-ЯЁ]\z/

  belongs_to :school, inverse_of: :school_classes
  has_many :students, dependent: :destroy, inverse_of: :school_class

  validates :number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than: 12 }

  validates :letter,
    presence: true,
    length: { maximum: 1 },
    format: { with: LETTER_FORMAT, message: "должна быть одна русская буква" }

  validates :students_count,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :number,
    uniqueness: {
      scope: %i[school_id letter],
      message: "класс с таким номером и буквой уже существует в этой школе"
    }
end
