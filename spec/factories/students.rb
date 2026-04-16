FactoryBot.define do
  factory :student do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    surname { Faker::Name.middle_name }
    association :school
    school_class { association :school_class, school: }
  end
end
