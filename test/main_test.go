package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	teststructure "github.com/gruntwork-io/terratest/modules/test-structure"
	"testing"
)



func Test(t *testing.T) {
	t.Parallel()

	exampleFolders := []string {
		"../examples/linux/static_single_disk",
		"../examples/linux/dynamic_single_disk",
		"../examples/linux/static_multi_disk",
		"../examples/linux/dynamic_multi_disk",
		/*
		"../examples/ovf/static_single_disk",
		"../examples/ovf/dynamic_single_disk",
		"../examples/ovf/static_multi_disk",
		"../examples/ovf/dynamic_multi_disk",
		*/
	}

	examples := map[string]*terraform.Options{}

	// Configure each test
	for _, folder := range exampleFolders {
		options := configureTerraformOptions(t, folder)
		teststructure.SaveTerraformOptions(t, folder, options)
		examples[folder] = options
	}

	// Run each test
	for folder, options := range examples {
		RunTest(t, folder, options)
	}
}

func RunTest(t *testing.T, folder string, options *terraform.Options) {
	defer teststructure.RunTestStage(t, "teardown", func() {
			terraform.Destroy(t, options)
	})

	teststructure.RunTestStage(t, "setup", func() {
		teststructure.SaveTerraformOptions(t, folder, options)
		terraform.InitAndApply(t, options)
	})

	teststructure.RunTestStage(t, "test", func() {
		testSSHUserPass(t, options, "ubuntu", "ubuntu")
	})
}