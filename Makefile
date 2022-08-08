install:
	terraform init
	tflint --init

format:
	terraform fmt
	conftest fmt tests

check: lint test

lint:
	tflint
	conftest fmt tests --check
	terraform fmt -check
	terraform validate

test:
	conftest test -p tests *.tf --combine

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
