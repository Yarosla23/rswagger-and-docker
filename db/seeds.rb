require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "Start create..........."

create(:school, :with_classes_and_students,
  name: "Школа №1",
  classes_count: 3,
  students_per_class: 20)

create(:school, :with_classes_and_students,
  name: "Школа №2",
  classes_count: 3,
  students_per_class: 10)

puts "School: #{School.count}"
puts "SchoolClass: #{SchoolClass.count}"
puts "Student: #{Student.count}"

puts "End create..........."
