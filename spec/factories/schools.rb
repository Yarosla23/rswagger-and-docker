FactoryBot.define do
  factory :school do
    sequence(:name) { |n| "#{Faker::Educator.secondary_school} ##{n}" }

    trait :with_classes_and_students do
      transient do
        classes_count { 3 }
        students_per_class { 20 }
      end

      after(:create) do |school, evaluator|
        create_list(:school_class, evaluator.classes_count, :with_students,
                   school: school,
                   students_count: evaluator.students_per_class)
      end
    end
  end
end
