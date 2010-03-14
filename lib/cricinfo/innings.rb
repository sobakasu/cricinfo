
module CricInfo
  
  class Innings
    attr_accessor :runs, :wickets, :overs, :team, :declared

    # returns a string summarising the innings data
    def summary
      return '' unless overs || runs  # overs can be blank if innings over
      out = "%s %d" % [team, runs]
      out += "/%d" % [wickets] if wickets
      out += " declared" if declared
      out += " (%s ov)" % [overs] if overs
      out += "\n"
      out
    end
  end

end
