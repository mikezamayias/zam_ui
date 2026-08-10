# frozen_string_literal: true

require "minitest/autorun"
require_relative "../scripts/check_workflow_policy"

class WorkflowPolicyTest < Minitest::Test
  def setup
    @workflow = WorkflowPolicy.load_workflow
  end

  def test_repository_workflow_satisfies_policy
    assert_empty WorkflowPolicy.errors(@workflow)
  end

  def test_rejects_every_forbidden_trigger
    WorkflowPolicy::FORBIDDEN_TRIGGERS.each do |trigger|
      workflow = copy
      workflow["on"][trigger] = {}
      refute_empty WorkflowPolicy.errors(workflow), "expected #{trigger} to be rejected"
    end
  end

  def test_rejects_dispatch_inputs
    workflow = copy
    workflow["on"]["workflow_dispatch"] = {"inputs" => {"ref" => {"type" => "string"}}}
    assert_includes WorkflowPolicy.errors(workflow), "workflow_dispatch must not declare inputs"
  end

  def test_rejects_hosted_runner
    workflow = copy
    verify_job(workflow)["runs-on"] = "macos-latest"
    assert_policy_error workflow, "runner labels"
  end

  def test_rejects_write_permissions
    workflow = copy
    workflow["permissions"] = {"contents" => "write"}
    assert_policy_error workflow, "permissions"
  end

  def test_rejects_secrets_and_environments
    secret_workflow = copy
    verify_job(secret_workflow)["steps"] << {"run" => "echo ${{ secrets.TOKEN }}"}
    assert_policy_error secret_workflow, "secret references"

    indexed_secret_workflow = copy
    verify_job(indexed_secret_workflow)["steps"] << {"run" => "echo ${{ secrets['TOKEN'] }}"}
    assert_policy_error indexed_secret_workflow, "secret references"

    environment_workflow = copy
    verify_job(environment_workflow)["environment"] = "production"
    assert_policy_error environment_workflow, "environment"
  end

  def test_rejects_persisted_checkout_credentials
    workflow = copy
    checkout(workflow)["with"]["persist-credentials"] = true
    assert_policy_error workflow, "credentials"
  end

  def test_rejects_non_event_checkout_refs
    workflow = copy
    checkout(workflow)["with"]["ref"] = "refs/heads/main"
    assert_policy_error workflow, "event SHA"
  end

  def test_rejects_unprotected_or_non_default_source_guards
    workflow = copy
    source_guard(workflow)["env"]["DEFAULT_BRANCH"] = "feature"
    assert_policy_error workflow, "protected branch"
  end

  def test_rejects_reusable_workflow_jobs_and_artifact_uploads
    reusable = copy
    verify_job(reusable)["uses"] = "owner/repository/.github/workflows/ci.yml@main"
    assert_policy_error reusable, "reusable workflow"

    upload = copy
    verify_job(upload)["steps"] << {"uses" => "actions/upload-artifact@v4"}
    assert_policy_error upload, "artifact upload"
  end

  private

  def copy
    Marshal.load(Marshal.dump(@workflow))
  end

  def verify_job(workflow)
    workflow.fetch("jobs").fetch("verify")
  end

  def checkout(workflow)
    verify_job(workflow).fetch("steps").find { |step| step["uses"].to_s.start_with?("actions/checkout@") }
  end

  def source_guard(workflow)
    verify_job(workflow).fetch("steps").find { |step| step["name"] == "Assert protected default-branch event" }
  end

  def assert_policy_error(workflow, fragment)
    assert WorkflowPolicy.errors(workflow).any? { |error| error.include?(fragment) }, WorkflowPolicy.errors(workflow).inspect
  end
end
