class SchoolSerializer < Panko::Serializer
  attributes :id, :name

  has_many :school_classes, serializer: SchoolClassSerializer
  has_many :students, serializer: StudentSerializer
end
