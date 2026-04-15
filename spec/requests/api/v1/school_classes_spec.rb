RSpec.describe "api/v1/school_classes", type: :request do
  path "/schools/{school_id}/classes" do
    parameter name: :school_id, in: :path, type: :integer

    get("Список классов школы") do
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

        let(:school) { School.create!(name: "Test School") }
        let(:school_id) { school.id }
        let!(:school_class) { school.school_classes.create!(number: 1, letter: "А") }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["data"].first["number"]).to eq(1)
          expect(body["data"].first["letter"]).to eq("А")
        end
      end
    end
  end
end