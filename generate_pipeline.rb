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

steps = []

if run_android
  steps << {
    'trigger' => 'android-builds',
    'build' => {
      'commit' => ENV['BUILDKITE_COMMIT'],
      'message' => ENV['BUILDKITE_MESSAGE'],
      'branch' => ENV['BUILDKITE_BRANCH']
    }
  }
end

if run_ios
  steps << {
    'trigger' => 'ios-builds',
    'build' => {
      'commit' => ENV['BUILDKITE_COMMIT'],
      'message' => ENV['BUILDKITE_MESSAGE'],
      'branch' => ENV['BUILDKITE_BRANCH']
    }
  }
end

if run_other
  steps << {
    'trigger' => 'other-builds',
    'build' => {
      'commit' => ENV['BUILDKITE_COMMIT'],
      'message' => ENV['BUILDKITE_MESSAGE'],
      'branch' => ENV['BUILDKITE_BRANCH']
    }
  }
end

pipeline = { 'steps' => steps }.to_yaml

puts pipeline
