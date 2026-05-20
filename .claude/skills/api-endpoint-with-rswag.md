# Skill: Create an API endpoint with rswag

Use this skill when adding or changing a public JSON API endpoint.

## Steps

1. Add the route under `namespace :api` and the current API version.
2. Add a controller under `app/controllers/api/v1` that inherits from `ActionController::API`.
3. Keep controller logic thin: permit params, authorize when needed, call an interactor, and render JSON.
4. Put business logic in an interactor, not in the controller or model.
5. Add or update an rswag spec under `spec/integration`.
6. In the rswag spec, define path, verb, tags, consumes, produces, request parameters, response schemas, and success/failure examples.
7. Use FactoryBot to prepare test data.
8. Run the endpoint spec and generate Swagger docs.

## Commands

```bash
bundle exec rspec spec/integration
bundle exec rails rswag:specs:swaggerize
```

## Checklist

- The endpoint returns JSON only.
- The interactor handles business rules.
- The rswag spec covers success and at least one failure case.
- The generated Swagger schema matches the actual response body.
