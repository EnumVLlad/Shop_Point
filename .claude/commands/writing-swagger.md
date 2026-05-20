---
description: How to cover API endpoints with rswag
---

# Writing Swagger specs with rswag

Use rswag specs for public API documentation and request coverage.

1. Add specs under `spec/integration`.
2. Require `swagger_helper`.
3. Define the path and HTTP verb.
4. Add tags, `consumes`, and `produces`.
5. Define body/path/query parameters.
6. Add JSON schemas for success and failure responses.
7. Use FactoryBot data in `let` blocks.
8. Use `run_test!` so the example both tests the endpoint and generates documentation.
9. Generate OpenAPI output with:

```bash
bundle exec rails rswag:specs:swaggerize
```

10. Review docs in the app at `/api-docs`.

Keep documented schemas in sync with real controller responses.
