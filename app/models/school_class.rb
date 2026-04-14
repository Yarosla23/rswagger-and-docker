class SchoolClass < ApplicationRecord
  belongs_to :school
  has_many :students, foreign_key: :class_id
end
