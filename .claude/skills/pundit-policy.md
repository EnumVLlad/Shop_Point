# Skill: Configure a Pundit policy

Use this skill when adding authorization for a controller action or domain resource.

## Steps

1. Add a policy under `app/policies` named after the resource.
2. Inherit from `ApplicationPolicy`.
3. Keep authorization decisions in policy methods such as `index?`, `show?`, `create?`, `update?`, and `destroy?`.
4. Keep business workflows in interactors; policies should answer whether an action is allowed.
5. Call `authorize(record)` or `policy_scope(scope)` from controllers.
6. Add RSpec coverage for allowed and denied roles.

## Project conventions

- Admin users may access admin workflows.
- Customer users should access only their own customer-facing resources.
- Do not duplicate Pundit checks in views as the source of truth.
- Do not place authorization logic inside models.

## Checklist

- Controller action calls Pundit.
- Policy has explicit tests for admin and customer behavior.
- Unauthorized access has a predictable response or redirect.
