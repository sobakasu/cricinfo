
module CricInfo

  module GameTypes
    GAMETYPE_UNKNOWN = 0
    GAMETYPE_TEST    = 1  # Test Match
    GAMETYPE_ODI     = 2  # ODI
    GAMETYPE_T20     = 3  # twenty twenty
  end

  class Game
    OVERS_ODI = 50

    include GameTypes

    attr_accessor :start_time, :name, :type, :innings
    # team1 is the team batting first (first innings)
    attr_accessor :team1, :team2

    def initialize
      @innings = []
      @type = GAMETYPE_ODI  # assume ODI by default
    end

    def inns1; @innings[0]; end
    def inns2; @innings[1]; end
    def inns3; @innings[2]; end
    def inns4; @innings[3]; end

    def add_innings
      @innings.push(Innings.new)
      @innings[-1]
    end

    def type_string
      gtype = ["Unknown game type", "Test match", "ODI", "T20"]
      type >= 0 && type <= GAMETYPE_T20 ? gtype[type] : gtype[0]
    end

    # returns a string summarising the game data
    def summary
      out = ''
      out += "%s: %s v %s (%s)\n" % [name, team1, team2, type_string]
      out += innings.collect { |i| i.summary }.join
      out
    end

  end

end
