install:
	terraform init
	tflint --init

format:
	terraform fmt -recursive
	conftest fmt tests

check: lint test

lint:
	tflint .
	tflint modules/**
	conftest fmt tests --check
	terraform fmt -check -recursive
	terraform validate

test:
	conftest test -p tests modules *.tf --combine --all-namespaces

scan:
	tfsec . --minimum-severity HIGH

cost:
	infracost breakdown --path .

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy

clean:
	rm -r .terraform
	rm -r .infracost
