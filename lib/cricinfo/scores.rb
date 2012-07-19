
module CricInfo
  class Scores
    include CricInfo::GameTypes

    DEBUG = false
    SCORES_HOST = "m.espncricinfo.com"
    SCORES_PATH = "/s/2497/Scores"

    # match name, team1, team2, inningsdata, start_time
    RE_MATCH = /matchId=.*?">([^:]+):<\/a>[^>]*>\s*(.*?)\s+v\s+(.*?)<\/a>.*?<\/tr>(.*?)<\/tr>(.*?Start time (.*?)\s*<\/b>)?/

    # team1/2, i1runs, i1wickets, i1decl, i2wickets, i2decl, overs
    # (overs optional)
    RE_INNINGS = /<b>\s*(.*?)\s*<\/b>\s*<b>\s*(\d+)(?:\/(\d+))?(d)?(?:\s*&amp;\s*(\d+)\/(\d+)(d)?)?\s*(?:\(([\d\.]+))?/

    # start_time (e.g. Start time 09:30 GMT)
    RE_START = /<b>\s*Start\s+time\s+(.*?)\s*<\/b>/

    attr_reader :games

    # create a new CricInfo::Scores object
    def initialize(html = nil)
      reload(html)
    end

    # reload score data
    def reload(html = nil)
      @games = []
      data = html || CricInfo::Scores.fetch_score_data
      data.gsub!(/<font.*?\/?>|<\/font>/, '')  # blow away font tags ftw

      # extract matches
      data.scan(RE_MATCH) do |match_name, team1, team2, idata, junk, start|

        game = Game.new
        game.name = match_name
        game.type = GAMETYPE_TEST if match_name.match(/Test/)
        game.type = GAMETYPE_T20 if match_name.match(/^\d+.. Match/)
        game.team1 = team1
        game.team2 = team2
        game.start_time = start ? Time.parse(start) : nil

        # parse innings data
        idata.scan(RE_INNINGS) do |data|
          team, i1runs, i1wickets, i1decl, i2runs, i2wickets, i2decl, overs = *data
          game.type = GAMETYPE_TEST if overs && overs.to_f > Game::OVERS_ODI
          inns1 = add_innings(game, team, i1runs, i1wickets, i1decl)
          inns2 = add_innings(game, team, i2runs, i2wickets, i2decl)

          # overs given applies to the last innings
          inns = inns2 ? inns2 : inns1
          inns.overs = overs ? overs : nil
        end

        # rorder innings: attempt to guess innings order.
        # find first valid permutation of innings order.
        list = game.innings.permutations.detect { |i| valid_innings_order(i) }
        game.innings = list if list

        @games.push(game)
      end

    end

    private

    # return true if the order of the list of innings is valid.
    def valid_innings_order(list)
      return true if list.length <= 1

      # any innings with overs attached must be the last innings.
      over_inns = list.detect { |i| i.overs }
      return false if over_inns && over_inns != list[-1]

      # the first and second innings must be different teams.
      return false if list[0].team == list[1].team

      # - a team can only bat twice in a row if it is following on.
      # -- (a team can only follow on if it is > 200 runs behind)
      (1...list.length).each do |i|
        if list[i].team == list[i - 1].team
          # team batted twice
          return false unless list[i - 2].runs > list[i - 1].runs + 200
        end
      end

      return true  # innings order is valid
    end

    def add_innings(game, team, runs, wickets, decl)
      return unless runs

      inns = game.add_innings
      inns.team = team
      inns.runs = runs.to_i
      inns.wickets = wickets ? wickets.to_i : 10
      inns.declared = decl ? true : false
      inns
    end

    def self.fetch_score_data
      Net::HTTP.get(SCORES_HOST, SCORES_PATH) || ''
    end

  end
end
