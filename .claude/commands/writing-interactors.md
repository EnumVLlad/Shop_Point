---
description: How to write interactors in this codebase
---

# Writing interactors

Interactors hold business workflows that should not live in controllers or views.

1. Place interactors under `app/interactors/<domain>`.
2. Include `Interactor` for a single step.
3. Include `Interactor::Organizer` for a workflow composed from steps.
4. Read inputs from `context`.
5. Write outputs needed by later steps or callers back to `context`.
6. Use `context.fail!(error: "...")` for expected business validation failures.
7. Keep database writes in the step that applies the change.
8. Wrap related writes in `ActiveRecord::Base.transaction`.
9. Keep controllers thin: they call the interactor and map success/failure to HTTP responses.

Transaction processing pattern:

1. `Transactions::Validate`
2. `Transactions::CalculatePoints`
3. `Transactions::Apply`
4. `Transactions::Process` organizer

Do not put request params, rendering, redirects, or UI concerns inside interactors.
