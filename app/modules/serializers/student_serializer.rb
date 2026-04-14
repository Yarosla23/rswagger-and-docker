class StudentSerializer < Panko::Serializer
  attributes :id, :first_name, :last_name, :surname, :school_id, :school_class_id
end
