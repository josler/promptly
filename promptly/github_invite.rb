require "octokit"

# Ask for a github user and a team name, and add that user to that team, inviting them to the organization if required.
# requires ENV "GITHUB_ACCESS_TOKEN" variable setup for access token. This can be set in .env if required.
# the access token must have admin org invite permissions
class GithubInvite

  def self.get_statements(args)
    cli = CLI.new
    client = Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])

    # get our team list
    teams = get_teams(cli, client)
    if teams.count == 0
      return [lambda {}] # if no teams, quit and do nothing
    end

    username = ""
    get_user = lambda do
      username = cli.ask_for("Github user name?")
      get_github_user(cli, client, username) || false
    end

    teamname = ""
    get_team = lambda do
      teamname = cli.ask_for("Team to add to?") { |q| q.default = ENV["GITHUB_DEFAULT_TEAM"] }
      if ! teams.include? teamname # fail if bad teamname
        cli.say_red("Team name not found")
        return false
      end
    end

    add_membership = lambda do
      add_team_membership(cli, client, teams[teamname].id, username) || false
    end

    [
      get_user,
      get_team,
      add_membership,
    ]
  end

  def self.get_teams(cli, client)
    teams = {}
    team_list = client.organization_teams(ENV["GITHUB_ORG"])
    loop do
      team_list.concat client.last_response.rels[:next].get.data
      break if (client.last_response.rels[:next].href == client.last_response.rels[:last].href)
    end
    team_list.each do |team|
      teams[team.name.downcase] = team
    end
    teams
  rescue Octokit::Error
    cli.say_red("Error fetching teams, check access token")
    return {}
  end

  def self.get_github_user(cli, client, username)
    user = client.user(username)
    cli.say_green("Found #{username} (#{user.name}), created: #{user.created_at}")
    user
  rescue Octokit::NotFound
    cli.say_red("User #{username} not found")
    return nil
  end

  def self.add_team_membership(cli, client, team_id, username)
    client.add_team_membership(team_id, username, { role: "member" })
    cli.say_green("Added #{username}")
    true
  rescue Octokit::Error
    cli.say_red("Error adding membership")
    return nil
  end
end
