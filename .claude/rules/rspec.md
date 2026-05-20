# RSpec and FactoryBot rules

- Write specs under `spec/` and require `rails_helper` for Rails-backed examples.
- Use FactoryBot with `create`, `build`, and traits instead of fixtures.
- Keep factories valid by default and override only fields that matter to the example.
- Prefer explicit expectations for business outcomes and persisted state changes.
- For interactors, assert `be_success` or `be_failure`, returned context values, and database side effects.
- Do not duplicate every validation in request specs when an interactor spec already owns that business rule.
- Use `let` for reusable setup and inline setup when it improves readability.
- Keep example descriptions behavior-focused, not implementation-focused.
