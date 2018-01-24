class CP
  def self.get_statements(args)
    cli = CLI.new

    master = lambda do
      system "git checkout master"
    end

    commit = ""
    ask_commit = lambda { commit = cli.ask_for("Commit ID?") { |q| q.validate = lambda {|a| !a.empty? }} }

    desc = ""
    ask_description = lambda { desc = cli.ask_for("Description?") { |q| q.validate = lambda {|a| !a.empty? }} }

    branch_name = lambda do
      branch_name = cli.ask_for("Branch name?") do |q|
        q.default = "jo/#{desc.gsub(" ", "-")}"
        q.validate = lambda {|a| !a.empty? }
      end
      system "git checkout -b #{branch_name}"
    end

    cherrypick = lambda do
      system "git cherry-pick #{commit}"
    end

    agree_push = cli.agree("Push to GH?")
    push = lambda { system "git push" }

    pr = lambda do
      text = "backported from elk/rails_5"
      system "hub pull-request -m \"#{desc}\n#{text}\" -o"
    end

    [
      master,
      ask_commit,
      ask_description,
      branch_name,
      cherrypick,
      agree_push,
      push,
      pr
    ]
  end
end
