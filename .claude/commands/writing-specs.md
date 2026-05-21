---
description: Standards for writing specs in this project
---

# Writing specs

Use RSpec with FactoryBot.

1. Put Rails-backed specs under `spec/` and require `rails_helper`.
2. Use factories from `spec/factories` instead of fixtures.
3. Keep each factory valid by default.
4. Override only the fields needed for the behavior under test.
5. Prefer behavior-focused example names.
6. Test the public contract of the object, not private methods.
7. For interactors, cover:
   - success or failure result
   - context values returned to callers
   - database records created or not created
   - persisted user balance and tier changes
8. For request/API specs, cover:
   - status code
   - response JSON shape
   - one representative success path
   - representative validation or authorization failures

Avoid brittle assertions on unrelated attributes.
