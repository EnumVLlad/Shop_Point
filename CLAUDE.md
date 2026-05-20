# Shop Point project context

Shop Point is a Rails loyalty application for customers and admins. Customers earn and redeem points from purchases, and admins can inspect users and transactions.

## Rules for AI

These rules are mandatory when modifying this codebase.

### Keep models thin

- `app/models` holds schema, associations, validations, scopes, and small persistence-related helpers only.
- Do not put multi-step business workflows, cross-model orchestration, point/tier calculations, or transaction composition inside ActiveRecord models.
- A method on a model must operate on that model's own state.

### Put all business logic in interactors

- Every business workflow lives under `app/interactors/<domain>` using the `interactor` gem.
- A single step includes `Interactor` or inherits from `ApplicationInteractor` when it needs context validations.
- A multi-step workflow uses `Interactor::Organizer`; `Transactions::Process` is the reference organizer.
- Inputs and outputs flow through `context`.
- Expected failures use `context.fail!(error: "...")`.
- Related database writes are wrapped in `ActiveRecord::Base.transaction`.
- Controllers stay thin: permit params, authorize with Pundit, call the interactor, and render the result.
- Do not put business rules in controllers, views, or models.
- Use Pundit policies in `app/policies` for authorization decisions.
- Details: `.claude/commands/writing-interactors.md`.

### Always write RSpec specs with or before the implementation

- No business code is considered complete without RSpec coverage in the same change.
- Prefer writing the spec first.
- Interactors belong in `spec/interactors/<domain>`.
- Interactor specs should assert `be_success` or `be_failure`, returned `context` values, and persisted database changes.
- Public API endpoints need rswag specs in `spec/integration` with one success and at least one failure case.
- Documented rswag schemas must match the real JSON response.
- Models need specs in `spec/models` for validations and non-trivial scopes.
- Use FactoryBot factories from `spec/factories`; factories should be valid by default.
- Details: `.claude/commands/writing-specs.md`, `.claude/rules/rspec.md`.

## Business domain

- Users have `points_balance` for spendable points and `tier_points` for lifetime tier progress.
- Tiers define cashback through `bonus_rate` percent and minimum required points through `min_points`.
- Purchase transactions are processed through `Transactions::Process`, which validates input, calculates cashback points, and applies balance and transaction changes.
- Redeemed points reduce `points_balance` only.
- Earned cashback increases both `points_balance` and `tier_points`.
- Transactions store purchase details including `purchase_amount`, `eligible_amount`, `redeemed_points`, `points`, `source`, and `order_number`.

## Main structure

- `app/models` contains thin ActiveRecord models: `User`, `Tier`, and `Transaction`.
- `app/controllers` contains HTML controllers and API controllers.
- `app/interactors/<domain>` contains business workflows.
- Transaction processing lives under `app/interactors/transactions`: `Validate`, `CalculatePoints`, `Apply`, organized by `Transactions::Process`.
- `app/policies` contains Pundit policies.
- `app/views` contains server-rendered Rails UI.
- `spec/factories` contains FactoryBot factories.
- `spec/interactors` contains interactor specs.
- `spec/integration` contains rswag request/API documentation specs.

## Testing

- RSpec is the test framework.
- FactoryBot syntax methods are included in `spec/rails_helper.rb`.
- API documentation is generated from rswag specs.
- Every change to business code ships with RSpec specs in the same commit or PR.

## API

- API endpoints are namespaced under `/api/v1`.
- Purchase transaction processing is exposed through `POST /api/v1/transactions`.
- Swagger UI is mounted at `/api-docs`.