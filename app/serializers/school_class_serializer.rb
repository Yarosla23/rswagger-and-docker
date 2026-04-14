class SchoolClassSerializer < Panko::Serializer
  attributes :id, :number, :letter, :students_count, :school_id

  def students_count
    object.students.count
  end
end
