variable "subnet" {
}

module "test" {
  source = "./test-module"
  # run once with count = 1, then set count = 2 and re-run
  count = 1
  # replace with real subnet
  subnet = "${var.subnet}"
}
