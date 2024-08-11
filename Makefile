check:
	@cargo watch -x check


watch:
	@cargo watch -x check -x test -x run


test:
	@cargo test

# will compute code coverage for your application code, ignoring your test functions.
coverage:
	@cargo tarpaulin --ignore-tests

lint:
	@cargo clippy

lint-fix:
	@cargo clippy --fix

# In our CI pipeline we would like to fail the linter check 
# if clippy emits any warnings. We can achieve it with
lint-ci:
	@cargo clippy -- -D warnings

fmt:
	@cargo fmt -- --check

# will check if there are any known vulnerabilities in your dependencies.
audit:
	@cargo audit


# cargo expand expands all macros in your code and prints the result to the console.
# cargo install cargo-expand
expand:
	@cargo expand

# clippy is included in the set of components installed by rustup 
# if you are using the default profile. Often CI environments use rustup’s minimal profile, which does not include clippy.
# You can easily install it with
# rustup component add clippy


# They also provide cargo-audit14, a convenient cargo sub-command to check if vulnerabilities have been reported for any of the crates in the dependency tree of your project.
# You can install it with
# cargo install cargo-audit