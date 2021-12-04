package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	teststructure "github.com/gruntwork-io/terratest/modules/test-structure"
	"strings"
	"testing"
	"time"
)

func TestLinuxStaticSingleDiskSsh(t *testing.T) {
	t.Parallel()

	exampleFolder := teststructure.CopyTerraformFolderToTemp(t, "../examples", "linux/static_single_disk")

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer teststructure.RunTestStage(t, "teardown", func() {
		terraformOptions := teststructure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example.
	teststructure.RunTestStage(t, "setup", func() {
		terraformOptions := configureLinuxStaticSingleDiskOptions(t, exampleFolder)

		// Save the options so later test stages can use them.
		teststructure.SaveTerraformOptions(t, exampleFolder, terraformOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors.
		terraform.InitAndApply(t, terraformOptions)
	})

	// Make sure we can SSH to the public instance directly from the public internet.
	teststructure.RunTestStage(t, "validate", func() {
		terraformOptions := teststructure.LoadTerraformOptions(t, exampleFolder)

		testSSHToHost(t, terraformOptions)
	})
}

func configureLinuxStaticSingleDiskOptions(t *testing.T, exampleFolder string) *terraform.Options {
	uniqueID := random.UniqueId()

	// Set some values for the remote state.
	vmName := fmt.Sprintf("terraform-linux-static-single-%s", uniqueID)
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
		//VarFiles:     []string{fmt.Sprintf("%s/%s", exampleFolder, "variables.tfvars")},
		// Variables to pass to our Terraform code using -var options.
		Vars: map[string]interface{}{
			"vm_name":  vmName,
			"networks": networkInterfaces,
		},
	})

	return terraformOptions
}

func testSSHToHost(t *testing.T, terraformOptions *terraform.Options) {
	// Run terraform output to get the value of the instance_ip attribute.
	ipAddress := terraform.Output(t, terraformOptions, "default_ip_address")

	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "ubuntu",
		Password:    "ubuntu",
	}

	// It can take a minute or so for the instance to boot up, so retry a few times.
	maxRetries := 30
	timeBetweenRetries := 20 * time.Second
	description := fmt.Sprintf("SSH to public host %s", ipAddress)

	// Run a simple echo command on the server.
	expectedText := "Hello, World"
	command := fmt.Sprintf("echo -n '%s'", expectedText)

	// Verify that we can SSH to the instance and run commands.
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, host, command)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		return "", nil
	})

	// Run a command on the server that results in an error.
	expectedText = "Hello, World"
	command = fmt.Sprintf("echo -n '%s' && exit 1", expectedText)
	description = fmt.Sprintf("SSH to public host %s with error command", ipAddress)

	// Verify that we can SSH to the instance, run the command which forces an error, and see the output.
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, host, command)

		if err == nil {
			return "", fmt.Errorf("Expected SSH command to return an error but got none")
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		return "", nil
	})
}
