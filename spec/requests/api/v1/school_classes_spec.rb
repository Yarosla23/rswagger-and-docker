require "swagger_helper"

RSpec.describe "api/v1/school_classes", type: :request do
  path "/schools/{school_id}/classes" do
    parameter name: :school_id, in: :path, schema: { type: :integer, format: :int32 }, required: true

    get("Вывести список классов школы") do
      operationId "getClassList"
      tags "classes"
      produces "application/json"

      response(200, "Список классов") do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: { "$ref" => "#/components/schemas/Class" }
            }
          }

        let(:school) { create(:school, name: "Test School") }
        let(:school_id) { school.id }
        let!(:school_class) { create(:school_class, school:, number: 1, letter: "А") }
        let!(:student) do
          create(
            :student,
            first_name: "Иван",
            last_name: "Иванов",
            surname: "Иванович",
            school:,
            school_class:
          )
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["data"].first["number"]).to eq(1)
          expect(body["data"].first["letter"]).to eq("А")
          expect(body["data"].first["students_count"]).to eq(1)
        end
      end
    end
  end
end
