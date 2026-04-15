class SchoolClass < ApplicationRecord
  belongs_to :school

  has_many :students

  validates :number,
    presence: true,
    numericality: {
      only_integer: true, greater_than: 0, less_than: 12
    }

  validates :letter,
    presence: true,
    length: { maximum: 1 },
    format: { with: /\A[А-ЯЁ]\z/, message: "должна быть одна русская буква" }

  validates :students_count,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    allow_nil: true

  validates :number,
    uniqueness: {
      scope: [ :school_id, :letter ], message: "класс с таким номером и буквой уже существует в этой школе"
    }
end
