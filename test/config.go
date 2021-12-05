package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func configureTerraformOptions(t *testing.T, exampleFolder string) *terraform.Options {
	uniqueID := random.UniqueId()

	// Set some values for the remote state.
	vmName := fmt.Sprintf("test-%s", uniqueID)
	ipAddress := fmt.Sprintf("172.32.255.%d/24", random.Random(2, 254))

	networkInterfaces := make(map[string]string)
	{
		networkInterfaces["Temporary"] = ipAddress
	}

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located.
		TerraformDir: exampleFolder,
		// Variables to pass to our Terraform code using -var options.
		Vars: map[string]interface{}{
			"vm_name":  vmName,
			"networks": networkInterfaces,
		},
	})

	return terraformOptions
}