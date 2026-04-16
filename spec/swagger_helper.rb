require "rails_helper"
require "yaml"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  components = YAML.load_file(Rails.root.join("app/modules/swagger/components.yaml")).deep_symbolize_keys!

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.3",
      info: {
        title: "API сервиса для тестового задания",
        version: "0.1.0"
      },
      tags: [
        {
          name: "students",
          description: "Всё что касается учеников"
        },
        {
          name: "classes",
          description: "Всё что касается классов"
        }
      ],
      paths: {},
      servers: [{url: "http://localhost:3000/api/v1"}],
      **components
    }
  }
  config.openapi_format = :yaml
end
