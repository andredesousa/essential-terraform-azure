config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  module = true
}

plugin "azurerm" {
  enabled = true
  version = "0.17.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
