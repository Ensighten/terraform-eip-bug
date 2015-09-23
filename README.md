# Bug output:

When trying to create instances with EIPs based on a count variable, the following error is produced after applying, increasing the count, and applying again:

Terraform version: Terraform v0.6.3

```
Error applying plan:

1 error(s) occurred:

* aws_eip.test-instance.0: diffs didn't match during apply. This is a bug with Terraform and should be reported.

Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.
```

The instances were created and EIPs were successfully bound despite the error. On running further plans and applies, no
changes are detected.

# Steps to reproduce:

1. Run `terraform apply --var subnet=$SOME_SUBNET_ID`
2. Modify main.tf to change the "count" variable for the "test" module to be 2
3. Run `terraform plan --var subnet=$SOME_SUBNET_ID` - observe that EIP instance attributes will be changed (from
   a concrete instance ID to an element function call into `aws_instance.test-instance.*.id)`:

   ```
        ~ module.test.aws_eip.test-instance.0
          instance: "<INSTANCE ID>" => "${element(aws_instance.test-instance.*.id, count.index)}"
   ```
4. Run `terraform apply --var subnet=$SOME_SUBNET_ID`, see error message given above.
