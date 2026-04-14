class SchoolClassSerializer < Panko::Serializer
  attributes :id, :number, :letter, :students_count, :school_id

  has_many :students, serializer: StudentSerializer
end
