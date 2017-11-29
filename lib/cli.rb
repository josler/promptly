require 'highline'

class CLI
  def initialize
    @cli = HighLine.new
  end

  def agree(question)
    lambda { result = @cli.agree(question) { |q| q.default = "yes" } }
  end

  def ask_for(query, &blk)
    @cli.ask(query, &blk)
  end

  def say_red(text)
    @cli.say @cli.color(text + "\n", :red, :bold)
  end

  def say_green(text)
    @cli.say @cli.color(text + "\n", :green)
  end

end
