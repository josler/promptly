#!/usr/bin/ruby

require_relative './lib/cli'
require_relative './lib/loop'
require_relative './pr'
require_relative './fixup'


possible_commands = {
  "pr" => PR,
  "fixup" => Fixup,
}

cli = CLI.new
unless ARGV.length > 0
  cli.say_red("Please pass valid command: #{possible_commands.keys.inspect}")
  return
end

found = possible_commands[ARGV[0]]
if found == nil
  cli.say_red("Please pass valid command: #{possible_commands.keys.inspect}")
  return
end

result = Loop.while_success(*found.get_statements(ARGV))
cli.say_red("Failed") unless result
