FactoryBot.define do
  factory :school_class do
    sequence(:number) { |n| (5..11).to_a[n % 7] }
    sequence(:letter) { |n| ('А'..'Г').to_a[n % 4] }
    students_count { 0 }
    association :school

    trait :with_students do
      transient do
        students_count { 20 }
      end

      after(:create) do |school_class, evaluator|
        create_list(:student, evaluator.students_count,
                   school: school_class.school,
                   school_class: school_class)
        school_class.update(students_count: evaluator.students_count)
      end
    end
  end
end
