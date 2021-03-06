#!/usr/bin/ruby

require 'dotenv'
require_relative './lib/cli'
require_relative './lib/loop'
require_relative './cp'
require_relative './pr'
require_relative './fixup'
require_relative './github_invite'

class Promptly
  def self.run(args)
    Dotenv.load(File.join(File.dirname(__FILE__), "../.env"))

    possible_commands = {
      "pr" => PR,
      "fixup" => Fixup,
      "cp" => CP,
      "invite" => GithubInvite,
    }

    cli = CLI.new
    unless args.length > 0
      cli.say_red("Please pass valid command: #{possible_commands.keys.inspect}")
      return
    end

    found = possible_commands[args[0]]
    if found == nil
      cli.say_red("Please pass valid command: #{possible_commands.keys.inspect}")
      return
    end

    result = Loop.while_success(*found.get_statements(args))
    cli.say_red("Failed") unless result
  end
end
