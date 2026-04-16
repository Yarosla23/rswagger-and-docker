require 'swagger_helper'

RSpec.describe 'api/v1/students', type: :request do
  path '/schools/{school_id}/classes/{class_id}/students' do
    parameter name: 'school_id', in: :path, schema: { type: :integer, format: :int32 }, required: true
    parameter name: 'class_id', in: :path, schema: { type: :integer, format: :int32 }, required: true, description: 'id класса'

    get("Вывести список студентов класса") do
      operationId "getClassStudentList"
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
        let!(:student) do
          school_class.students.create!(
            first_name: "John",
            last_name: "Doe",
            surname: "Smith",
            school_id: school.id,
            school_class_id: school_class.id
          )
        end

        run_test!
      end
    end
  end

  path "/students" do
    post("Регистрация нового студента") do
      operationId "createStudent"
      tags "students"
      consumes "application/json"
      produces "application/json"
      parameter name: :student,
        in: :body,
        required: true,
        description: "Новый студент",
        schema: { "$ref" => "#/components/schemas/Student" }

      response(201, "Successful operation") do
        header "X-Auth-Token",
          schema: { type: :string },
          description: "Токен для последующей авторизации, например sha256(user_id + secret_salt)",
          example: "3525dcdddea774939652f7f11df6d7db10a9db35a5d758c64d600a00c1cc41be"

        schema "$ref" => "#/components/schemas/Student"

        let(:school) { School.create!(name: "Test School") }
        let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }
        let(:student) do
          {
            first_name: "Вячеслав",
            last_name: "Абдурахмангаджиевич",
            surname: "Мухобойников-Сыркин",
            school_id: school.id,
            class_id: school_class.id
          }
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["first_name"]).to eq("Вячеслав")
          expect(response.headers["X-Auth-Token"]).to be_present
        end
      end

      response(405, "Invalid input") do
        let(:student) { { first_name: "" } }
        run_test!
      end
    end
  end

  path "/students/{user_id}" do
    delete("Удалить студента") do
      operationId "deleteStudent"
      tags "students"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :user_id,
        in: :path,
        required: true,
        description: "id студента",
        schema: { type: :integer, format: :int64 }

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
      let(:Authorization) { "Bearer #{student_record.auth_token}" }

      response(400, "Некорректный id студента") do
        let(:user_id) { 0 }
        let(:Authorization) { "Bearer invalidtoken" }
        run_test!
      end

      response(401, "Некорректная авторизация") do
        let(:Authorization) { "Bearer invalidtoken" }
        run_test!
      end
    end
  end

  describe "POST /api/v1/students" do
    it "accepts class_id from the top-level JSON body" do
      school = School.create!(name: "Test School")
      school_class = school.school_classes.create!(number: 1, letter: "А")

      post "/api/v1/students",
        params: {
          first_name: "Вячеслав",
          last_name: "Абдурахмангаджиевич",
          surname: "Мухобойников-Сыркин",
          school_id: school.id,
          class_id: school_class.id
        }.to_json,
        headers: {
          "CONTENT_TYPE" => "application/json",
          "ACCEPT" => "application/json"
        }

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body["class_id"]).to eq(school_class.id)
      expect(body["school_id"]).to eq(school.id)
      expect(response.headers["X-Auth-Token"]).to be_present
      expect(response.headers["X-Auth-Token"]).to eq(Student.find(body["id"]).auth_token)
    end
  end

  describe "DELETE /api/v1/students/:user_id" do
    it "deletes a student with a valid bearer token" do
      school = School.create!(name: "Delete School")
      school_class = school.school_classes.create!(number: 1, letter: "А")
      student = Student.create!(
        first_name: "Иван",
        last_name: "Иванович",
        surname: "Иванов",
        school_id: school.id,
        school_class_id: school_class.id
      )

      delete "/api/v1/students/#{student.id}",
        headers: {
          "Authorization" => "Bearer #{student.auth_token}"
        }

      expect(response).to have_http_status(:no_content)
      expect(Student.find_by(id: student.id)).to be_nil
    end
  end
end
