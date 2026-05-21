require "rails_helper"
require "rswag/specs"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "Shop Point API",
        version: "v1"
      },
      paths: {},
      servers: [
        {
          url: "http://localhost:3000",
          description: "Development server"
        }
      ],
      components: {
        schemas: {
          error: {
            type: :object,
            properties: {
              error: { type: :string }
            },
            required: %w[error]
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
