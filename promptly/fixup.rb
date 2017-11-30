class Fixup
  def self.get_statements(args)
    cli = CLI.new

    agree_fixup = cli.agree("Do fixup?")
    do_fixup = lambda do
      system "git add ."
      system "git commit --amend --no-edit"
    end

    agree_push = cli.agree("Push to GH?")
    do_push = lambda { system "git push" }

    [
      agree_fixup,
      do_fixup,
      agree_push,
      do_push
    ]
  end
end
