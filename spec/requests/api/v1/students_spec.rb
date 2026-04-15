require 'swagger_helper'

RSpec.describe 'api/v1/students', type: :request do
  path "/students" do
    post("Регистрация нового студента") do
      tags "students"
      consumes "application/json"
      produces "application/json"
      parameter name: :student, in: :body, schema: { "$ref" => "#/components/schemas/Student" }

      response(201, "все ок, создалось") do
        let(:school) { School.create!(name: "Test School") }
        let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }
        let(:student) do
          {
            first_name: "Вячеслав",
            last_name: "Абдурахмангаджиевич",
            surname: "Мухобойников-Сыркин",
            school_id: school.id,
            school_class_id: school_class.id
          }
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["first_name"]).to eq("Вячеслав")
          expect(response.headers["Authorization"]).to match(/^Bearer /)
        end
      end

      response(422, "некорректный ввод") do
        let(:student) { { first_name: "" } }
        run_test!
      end
    end
  end

  path "/students/{user_id}" do
    delete("Удалить студента") do
      tags "students"
      produces "application/json"
      parameter name: :user_id, in: :path, schema: { type: :integer }
      parameter name: :Authorization, in: :header, schema: { type: :string }, required: true

      let(:school) { School.create!(name: "Test School") }
      let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }
      let!(:student_record) do
        Student.create!(
          first_name: "Вячеслав",
          last_name: "Абдурахмангаджиевич",
          surname: "Мухобойников-Сыркин",
          school_id: school.id,
          school_class_id: school_class.id
        )
      end
      let(:user_id) { student_record.id }
      let(:Authorization) { "Bearer #{Digest::SHA256.hexdigest("#{student_record.id}#{Rails.application.credentials.secret_key_base}")}" }

      response(204, "No Content") do
        run_test! do
          expect(Student.find_by(id: user_id)).to be_nil
        end
      end

      response(400, "Некорректный id студента") do
        let(:user_id) { 0 }
        let(:Authorization) { "Bearer invalidtoken" }
        run_test!
      end

      response(401, "Unauthorized") do
        let(:Authorization) { "Bearer invalidtoken" }
        run_test!
      end
    end
  end

  path '/schools/{school_id}/classes/{class_id}/students' do
    parameter name: 'school_id', in: :path, type: :string, description: 'school_id'
    parameter name: 'class_id', in: :path, type: :string, description: 'class_id'

    get("Список студентов") do
      tags "students", "classes"
      produces "application/json"

      response(200, "Список студентов") do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: { "$ref" => "#/components/schemas/Student" }
            }
          }

        let(:school) { School.create!(name: "Test School") }
        let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }
        let(:school_id) { school.id }
        let(:class_id) { school_class.id }
        let!(:student) { school_class.students.create!(first_name: "John", last_name: "Doe", surname: "Smith", school:) }

        run_test!
      end
    end
  end
end
