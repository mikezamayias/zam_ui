#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "pathname"

abort "usage: #{$PROGRAM_NAME} TOOLCHAIN_MANIFEST" unless ARGV.length == 1

manifest = JSON.parse(File.read(ARGV.fetch(0)))
expected_keys = %w[dart_version flutter_revision flutter_version]
abort "toolchain manifest must contain exactly: #{expected_keys.join(", ")}" unless manifest.keys.sort == expected_keys

abort "self-hosted CI requires macOS" unless RUBY_PLATFORM.include?("darwin")
abort "self-hosted CI requires ARM64" unless `uname -m`.strip == "arm64"

def executable_path(name)
  path = ENV.fetch("PATH", "").split(File::PATH_SEPARATOR)
    .map { |directory| File.join(directory, name) }
    .find { |candidate| File.file?(candidate) && File.executable?(candidate) }
  abort "#{name} is not available on PATH" unless path

  Pathname.new(path).realpath.to_s
end

flutter_path = executable_path("flutter")
dart_path = executable_path("dart")
flutter_root = File.expand_path("..", File.dirname(flutter_path))
expected_dart_path = File.join(flutter_root, "bin", "dart")
abort "Dart must be supplied by the selected Flutter SDK" unless dart_path == Pathname.new(expected_dart_path).realpath.to_s

stdout, stderr, status = Open3.capture3(flutter_path, "--version", "--machine")
abort "unable to inspect Flutter SDK: #{stderr.strip}" unless status.success?

actual = JSON.parse(stdout)
checks = {
  "Flutter version" => [actual["frameworkVersion"], manifest.fetch("flutter_version")],
  "Flutter revision" => [actual["frameworkRevision"], manifest.fetch("flutter_revision")],
  "Dart version" => [actual["dartSdkVersion"], manifest.fetch("dart_version")]
}
checks.each do |name, (observed, expected)|
  abort "#{name} mismatch: expected #{expected.inspect}, found #{observed.inspect}" unless observed == expected
end

puts "Verified Flutter #{manifest.fetch("flutter_version")} (#{manifest.fetch("flutter_revision")}) with Flutter-owned Dart #{manifest.fetch("dart_version")}."
