# AutomationTest
Summary
Perl Mouse Mojo WebApp from scratch with REST endpoint tests

Test::Mojo → Simulates HTTP requests, validates content/JSON.

Test::More → Asserts, counts, and labels tests.

Test::Harness / Harness2 → Runs multiple .t files in order, aggregates results, supports parallel and fail-fast.

Combine them for robust web portal testing including validations, duplicates, required fields, and authorization.


Test::Harness isn’t just about running tests; it has several advanced capabilities for web portal testing:

Order of Tests

Ensures foundational tests (like authentication, DB setup) run before functional tests.

Example: 01_auth.t → 02_create_user.t → 03_update_user.t → 04_delete_user.t


