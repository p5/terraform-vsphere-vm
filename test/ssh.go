package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
	"time"
)

func testSSHUserPass(t *testing.T, terraformOptions *terraform.Options, username string, password string) {
	ipAddress := terraform.Output(t, terraformOptions, "default_ip_address")

	host := ssh.Host{
		Hostname: ipAddress,
		SshUserName: username,
		Password: password,
	}

	maxRetries := 30
	timeBetweenRetries := 20 * time.Second
	description := fmt.Sprintf("SSH to host %s", host.Hostname)

	expectedText := terraformOptions.Vars["vm_name"].(string)
	command := "cat /etc/hostname"

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, host, command)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		logger.Log(t, fmt.Sprintf("Successfully SSH'd to host %s", host.Hostname))
		logger.Log(t, fmt.Sprintf("SSH command returned: %s", actualText))
		return "", nil
	})
}