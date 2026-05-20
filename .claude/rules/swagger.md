# Swagger and rswag rules

- Cover API endpoints with rswag specs under `spec/integration`.
- Require `swagger_helper` in rswag specs.
- Define path, HTTP verb, tags, consumes, produces, parameters, response schemas, and representative success and failure responses.
- Keep schemas aligned with actual JSON responses from controllers.
- Use factories to prepare data for `run_test!` examples.
- Generate docs with `bundle exec rails rswag:specs:swaggerize`.
- Expose generated docs through `/api-docs`.
- Do not document private HTML controller routes as public API endpoints.
