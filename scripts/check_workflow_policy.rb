#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

module WorkflowPolicy
  module_function

  WORKFLOW = ".github/workflows/main.yaml"
  DEFAULT_BRANCH = "main"
  RUNNER_LABELS = %w[self-hosted macOS ARM64 zam-ui-manual].freeze
  FORBIDDEN_TRIGGERS = %w[branch_protection_rule check_run check_suite create delete deployment deployment_status discussion discussion_comment fork gollum issue_comment issues label merge_group milestone page_build project project_card project_column public pull_request pull_request_review pull_request_review_comment pull_request_target push registry_package release repository_dispatch schedule status watch workflow_call workflow_run].freeze

  def load_workflow(path = WORKFLOW)
    YAML.safe_load(File.read(path), aliases: false)
  end

  def errors(workflow)
    failures = []
    triggers = workflow.fetch("on", {})
    failures << "only workflow_dispatch may trigger this workflow" unless triggers.is_a?(Hash) && triggers.keys == ["workflow_dispatch"]
    failures << "workflow_dispatch must not declare inputs" unless triggers["workflow_dispatch"].nil? || triggers["workflow_dispatch"] == {}
    forbidden = triggers.is_a?(Hash) ? triggers.keys & FORBIDDEN_TRIGGERS : []
    failures << "forbidden triggers: #{forbidden.join(", ")}" unless forbidden.empty?

    failures << "top-level permissions must be exactly contents: read" unless workflow["permissions"] == {"contents" => "read"}
    failures << "concurrency must be bounded and must not cancel an attended run" unless workflow.dig("concurrency", "group") == "zam-ui-manual-default-branch" && workflow.dig("concurrency", "cancel-in-progress") == false

    jobs = workflow.fetch("jobs", {})
    failures << "workflow must define jobs" unless jobs.is_a?(Hash) && !jobs.empty?
    jobs.each do |job_name, job|
      failures << "#{job_name} must not call a reusable workflow" if job.key?("uses")
      failures << "#{job_name} must use only the repository-scoped runner labels" unless job["runs-on"] == RUNNER_LABELS
      failures << "#{job_name} must have a bounded timeout" unless job["timeout-minutes"].is_a?(Integer) && job["timeout-minutes"].between?(1, 90)
      failures << "#{job_name} must not reference an environment" if job.key?("environment")
      if job.key?("permissions") && job["permissions"] != {"contents" => "read"}
        failures << "#{job_name} permissions must remain read-only"
      end

      steps = job.fetch("steps", [])
      checkout_indexes = steps.each_index.select { |index| steps[index]["uses"].to_s.start_with?("actions/checkout@") }
      failures << "#{job_name} must contain exactly one checkout" unless checkout_indexes.length == 1
      next unless checkout_indexes.length == 1

      checkout_index = checkout_indexes.first
      checkout = steps[checkout_index]
      failures << "checkout must use only the event SHA" unless checkout.dig("with", "ref") == "${{ github.sha }}"
      failures << "checkout credentials must not persist" unless checkout.dig("with", "persist-credentials") == false

      source_guard = steps[0...checkout_index].find { |step| step["name"] == "Assert protected default-branch event" }
      failures << "protected branch and event SHA must be asserted before checkout" unless source_guard?(source_guard)

      identity_index = steps.each_index.find { |index| steps[index]["name"] == "Verify checked-out identity" }
      failures << "checked-out identity must be verified immediately after checkout" unless identity_index == checkout_index + 1 && checkout_identity_guard?(steps[identity_index])

      install_index = steps.each_index.find { |index| steps[index]["name"] == "Resolve dependencies" }
      toolchain_index = steps.each_index.find { |index| steps[index]["name"] == "Verify exact toolchain" }
      failures << "exact toolchain verification must run before dependency installation" unless toolchain_index && install_index && toolchain_index < install_index
      cleanup_steps = steps.select { |step| step["name"] == "Clean isolated runtime" }
      failures << "cleanup must always run" unless cleanup_steps.one? && cleanup_steps.first["if"] == "${{ always() }}"
      failures << "cleanup must derive and validate the runtime path independently" unless cleanup_runtime_guard?(cleanup_steps.first)
    end

    walk(workflow) do |key, value|
      text = value.to_s
      failures << "secret references are forbidden" if text.match?(/\bsecrets\s*(?:\.|\[)/i)
      failures << "artifact upload actions are forbidden" if text.match?(/actions\/upload-artifact@/i)
      failures << "write permissions are forbidden" if key == "permissions" && value.is_a?(Hash) && value.values.any? { |permission| permission.to_s == "write" }
    end

    failures.uniq
  end

  def source_guard?(step)
    return false unless step.is_a?(Hash)

    env = step.fetch("env", {})
    run = step["run"].to_s
    env == {
      "DEFAULT_BRANCH" => DEFAULT_BRANCH,
      "EVENT_DEFAULT_BRANCH" => "${{ github.event.repository.default_branch }}",
      "EVENT_NAME" => "${{ github.event_name }}",
      "EVENT_REF" => "${{ github.ref }}",
      "EVENT_REF_NAME" => "${{ github.ref_name }}",
      "EVENT_REF_PROTECTED" => "${{ github.ref_protected }}",
      "EVENT_SHA" => "${{ github.sha }}",
      "WORKFLOW_REF" => "${{ github.workflow_ref }}"
    } && run.include?("refs/heads/$DEFAULT_BRANCH") && run.include?("@refs/heads/$DEFAULT_BRANCH") && run.include?("EVENT_SHA")
  end

  def checkout_identity_guard?(step)
    step.is_a?(Hash) && step.dig("env", "EVENT_SHA") == "${{ github.sha }}" && step["run"].to_s.include?("git rev-parse HEAD")
  end

  def cleanup_runtime_guard?(step)
    return false unless step.is_a?(Hash)

    env = step.fetch("env", {})
    run = step["run"].to_s
    env == {
      "RUN_ID" => "${{ github.run_id }}",
      "RUN_ATTEMPT" => "${{ github.run_attempt }}"
    } && run.include?('expected_root="$RUNNER_TEMP/zam-ui-manual-$RUN_ID-$RUN_ATTEMPT"') &&
      run.include?('cleanup_root="${ZAM_CI_ROOT:-$expected_root}"') &&
      run.include?('test -n "$cleanup_root"') &&
      run.include?('test "$cleanup_root" = "$expected_root"') &&
      run.include?('test ! -L "$cleanup_root"') &&
      run.include?('rm -rf -- "$cleanup_root" .dart_tool build coverage pubspec.lock')
  end

  def walk(value, key = nil, &block)
    yield key, value
    case value
    when Hash
      value.each { |child_key, child| walk(child, child_key, &block) }
    when Array
      value.each { |child| walk(child, key, &block) }
    end
  end
end

if $PROGRAM_NAME == __FILE__
  failures = WorkflowPolicy.errors(WorkflowPolicy.load_workflow(ARGV.fetch(0, WorkflowPolicy::WORKFLOW)))
  if failures.empty?
    puts "Workflow policy passed."
  else
    warn failures.map { |failure| "- #{failure}" }.join("\n")
    exit 1
  end
end
