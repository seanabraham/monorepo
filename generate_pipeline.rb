#!/usr/bin/env ruby
require 'yaml'

merge_base = `git merge-base HEAD master`.strip

diff = `git diff #{merge_base}..HEAD`

run_android = false
run_ios = false
run_other = true

diff.split('\n').each do |file|
  if File.dirname(file) == 'android'
    run_android = true
    next
  end

  if File.dirname(file) == 'ios'
    run_ios = true
    next
  end

  if File.dirname(file) == 'other'
    run_android = true
    run_ios = true
    run_other = true
  end
end

if run_android
  android_trigger = {
    trigger: "android-builds",
    build: {
      commit: ENV['BUILDKITE_COMMIT'],
      message: ENV['BUILDKITE_MESSAGE'],
      branch: ENV['BUILDKITE_BRANCH']
    }
  }.to_yaml
  puts android_trigger
end

if run_ios
  ios_trigger = {
    trigger: "ios-builds",
    build: {
      commit: ENV['BUILDKITE_COMMIT'],
      message: ENV['BUILDKITE_MESSAGE'],
      branch: ENV['BUILDKITE_BRANCH']
    }
  }.to_yaml
  puts_ios_trigger
end

if run_other
  other_trigger = {
    trigger: "other-builds",
    build: {
      commit: ENV['BUILDKITE_COMMIT'],
      message: ENV['BUILDKITE_MESSAGE'],
      branch: ENV['BUILDKITE_BRANCH']
    }
  }.to_yaml
  puts other_trigger
end
