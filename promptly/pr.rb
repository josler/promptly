class PR
  def self.get_statements(args)
    cli = CLI.new

    desc = ""
    ask_description = lambda { desc = cli.ask_for("Description?") { |q| q.validate = lambda {|a| !a.empty? }} }

    branch_name = lambda do
      branch_name = cli.ask_for("Branch name?") do |q|
        q.default = "jo/#{desc.gsub(" ", "-")}"
        q.validate = lambda {|a| !a.empty? }
      end
      system "git checkout -b #{branch_name}"
    end

    commit_text = lambda do
      text = cli.ask_for("Commit text?") { |q| q.default = desc }
      system "git add ."
      system "git commit -m \"#{text}\""
    end

    agree_push = cli.agree("Push to GH?")
    push = lambda { system "git push -u" }

    agree_pr = cli.agree("Create PR?")
    pr_title = lambda do
      text = cli.ask_for("PR title?") { |q| q.default = desc }
      system "hub pull-request -m \"#{text}\" -o"
    end

    [
      ask_description,
      branch_name,
      commit_text,
      agree_push,
      push,
      agree_pr,
      pr_title
    ]
  end
end
