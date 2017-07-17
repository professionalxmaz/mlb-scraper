require 'pry'

class MlbScraper::CLI

  @@team_list = [
    orioles = ["orioles", "http://m.orioles.mlb.com/roster/"],
    redsox = ["redsox", "http://m.redsox.mlb.com/roster/"],
    whitesox = ["whitesox", "http://m.whitexox.mlb.com/roster/"],
    indians = ["indians", "http://m.indians.mlb.com/roster/"],
    tigers = ["tigers", "http://m.tigers.mlb.com/roster/"],
    astros = ["astros", "http://m.astros.mlb.com/roster/"],
    royals = ["royals", "http://m.royals.mlb.com/roster/"],
    angels = ["angels", "http://m.angels.mlb.com/roster/"],
    twins = ["twins", "http://m.twins.mlb.com/roster/"],
    yankees = ["yankees", "http://m.tigers.mlb.com/roster/"],
    athletics = ["athletics", "http://m.athletics.mlb.com/roster/"],
    mariners = ["mariners", "http://m.mariners.mlb.com/roster/"],
    rays = ["rays", "http://m.rays.mlb.com/roster/"],
    rangers = ["rangers", "http://m.rangers.mlb.com/roster/"],
    bluejays = ["bluejays", "http://m.bluejays.mlb.com/roster/"],
    dbacks = ["dbacks", "http://m.dbacks.mlb.com/roster/"],
    braves = ["braves", "http://m.braves.mlb.com/roster/"],
    cubs = ["cubs", "http://m.cubs.mlb.com/roster/"],
    reds = ["reds", "http://m.reds.mlb.com/roster/"],
    rockies = ["rockies", "http://m.rockies.mlb.com/roster/"],
    dodgers = ["dodgers", "http://m.dodgers.mlb.com/roster/"],
    marlins = ["marlins", "http://m.marlins.mlb.com/roster/"],
    brewers = ["brewers", "http://m.brewers.mlb.com/roster/"],
    mets = ["mets", "http://m.mets.mlb.com/roster/"],
    phillies = ["phillies", "http://m.phillies.mlb.com/roster/"],
    pirates = ["pirates", "http://m.pirates.mlb.com/roster/"],
    padres = ["padres", "http://m.padres.mlb.com/roster/"],
    giants = ["giants", "http://m.giants.mlb.com/roster/"],
    cardinals = ["cardinals", "http://m.cardinals.mlb.com/roster/"],
    nats = ["nats", "http://m.nats.mlb.com/roster/"]
  ]

  $url = nil

  def call
    team
  end

  def team
    #display list of teams
    x = 1
    @@team_list.each {|team|
      puts "#{x}. #{team[0].capitalize}"
      name = team[0].capitalize
      number = x
      url = team[1]
      MlbScraper::Team.new(name, number, url)

      x += 1
    }
    make_teams
  end

  def make_teams
    puts "Which team would you like to see player info for? Enter the number, or team name (as shown above), and press enter."

    input = gets.strip

    #if input is between 1-32 OR matches the names of the teams? = true
    if input.to_i.between?(1,30) || check_team_name(input)
      verify(input)
    else
      puts "I don't recognize that team, please try again.  Enter the name or number of the team and press enter."
      make_teams
    end
  end

  def check_team_name(input)
    @@team_list.each {|team|
      team.each {|name|
        input.downcase == name.downcase ? true : false
      }
    }
  end

  def verify(input)
    MlbScraper::Team.all.each {|team|
      if input.downcase == team.name.downcase || input.to_i == team.number
        MlbScraper::Scraper.new(team.url)
        $url = team.url
        #instantiate scraper with team url
        #pass the team selection
        menu
      end
    }
  end

  def menu

    puts "

    Which position would you like to view?

    1. Pitchers
    2. Catchers
    3. Infield
    4. Outfield
    5. Full Roster

    Type 'exit' to quit"


    input = gets.strip


    if input == "1"
      puts "PITCHERS:

      "
      MlbScraper::Scraper.pitchers($url)

      list_players


    elsif input == "2"
      puts "CATCHERS:

      "

      MlbScraper::Scraper.catchers($url)

      list_players

    elsif input == "3"
      puts "INFIELD:

      "
      MlbScraper::Scraper.infield($url)

      list_players

    elsif input == "4"
      puts "OUTFIELD:

      "
      MlbScraper::Scraper.outfield($url)

      list_players

    elsif input == "5"
      puts "FULL ROSTER:

      "
      MlbScraper::Scraper.full_roster($url)

      list_players


    elsif input == "exit"
      quit
    else
      puts "Sorry, I don't recognize that input."
      menu
    end

    get_player_info?
  end


  def get_player_info?
    p "If you want to see more info on a player, enter their number and press ENTER.  Otherwise, if you want to go back, type 'back'.  Or, just type 'quit'"

    input = gets.strip
    arr = (0..100).to_a

    if input == "quit"
      quit
    elsif input == "back"
      menu
    elsif arr.include?(input.to_i)
      MlbScraper::Player.all.each {|player|
        if player.number.to_i == input.to_i
          MlbScraper::Player.player_info(player.url)
          get_player_info?
        end
      }
    else
          p "I don't recognize that player's number!"
          get_player_info?
    end
  end


  def quit
    abort("See you soon!")
  end


  def list_players
    MlbScraper::Player.all.each {|player|
      puts "
      Name: #{player.name}
      Number: #{player.number}
      Batting / Throwing: #{player.bt}
      Height: #{player.height}
      Weight: #{player.weight}
      Birthday: #{player.dob}
      "
    }
  end




end
