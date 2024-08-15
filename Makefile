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

# spot unused dependencies
udepds:
	@cargo udeps

# `.` telling docker to look for Dockerfile in the current directory
build:
	@docker build -t zero2prod --file Dockerfile .

docker-run:
	@docker run -p 8000:8000 zero2prod


# Generate query metadata to support offline compile-time verification.
# Saves metadata for all invocations of `query!` and related macros to
# `sqlx-data.json` in the current directory, overwriting if needed.
prepare:
	@cargo sqlx prepare -- --lib

# cargo-udeps scans your Cargo.toml file and checks if all the crates listed under [dependencies] have actually been used in the project.
# cargo install cargo-udeps


# clippy is included in the set of components installed by rustup 
# if you are using the default profile. Often CI environments use rustup’s minimal profile, which does not include clippy.
# You can easily install it with
# rustup component add clippy


# They also provide cargo-audit14, a convenient cargo sub-command to check if vulnerabilities have been reported for any of the crates in the dependency tree of your project.
# You can install it with
# cargo install cargo-audit