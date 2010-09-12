require File.dirname(__FILE__) + '/spec_helper.rb'
include CricInfo::GameTypes

describe CricInfo::Scores do

  FIXTURE_PATH = File.dirname(__FILE__) + '/fixtures'

  # Scores1.html
  it "should initialize and parse score data 1" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(1))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 2
    game = c.games[0]
    game.name.should == "5th ODI"
    game.type.should == GAMETYPE_ODI
    game.team1.should == "NZ"
    game.team2.should == "AUS"
    game.inns1.runs.should == 219
    game.inns1.wickets.should == 8
    game.inns1.overs.should == "46.4"
  end
  
  # Scores4.html
  it "should initialize and parse score data 4" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(4))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 3   # 1 ODI, 1 test, 1 not started
    game = c.games[1]
    game.name.should == "5th ODI"
    game.type.should == GAMETYPE_ODI
    game.team1.should == "NZ"
    game.team2.should == "AUS"
    game.inns1.runs.should == 241
    game.inns1.wickets.should == 9
    game.inns2.runs.should == 129
    game.inns2.wickets.should == 5
    game.inns2.overs.should == "33.3"

    game = c.games[0]  # not started
    game.team1.should == "MUMB"
    game.team2.should == "RTHAN"
    game.start_time.should == Time.parse("09:30 GMT")
  end

  # Scores5.html
  it "should initialize and parse score data 5" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(5))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 1
    game = c.games[0]  # BAN v ENG
    game.team1.should == "BAN"
    game.team2.should == "ENG"
    game.inns1.team.should == "ENG"  # note: order different to game team names
    game.inns2.team.should == "BAN"
    game.inns1.declared.should == true
  end

  # Scores6.html
  # 3 innings
  it "should initialize and parse score data 6" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(6))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 2
    game = c.games[1]  # BAN v ENG
    game.innings.length.should == 3

    game.inns1.team.should == "ENG"
    game.inns2.team.should == "BAN"
    game.inns3.team.should == "ENG"
  end

  # Scores7.html  (doctored from Scores6.html)
  # 4 innings
  it "should initialize and parse score data 7" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(7))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 2
    game = c.games[1]  # BAN v ENG
    game.innings.length.should == 4

    game.inns1.team.should == "ENG"
    game.inns1.runs.should == 599
    game.inns1.wickets.should == 6
    game.inns1.declared.should == true
    game.inns2.team.should == "BAN"
    game.inns2.runs.should == 296
    game.inns2.wickets.should == 10
    game.inns3.team.should == "ENG"
    game.inns4.team.should == "BAN"
  end

  # Scores8.html
  # (team with space in the name)

  it "should initialize and parse score data 8" do
    CricInfo::Scores.should_receive(:fetch_score_data).and_return(fixture(8))
    c = CricInfo::Scores.new
    c.should_not be_nil

    c.games.length.should == 3
    game = c.games[1]  # LIONS v SOUTH AUST
    game.innings.length.should == 1

    game.team1.should == "LIONS"
    game.team2.should == "SOUTH AUST"
    game.inns1.team.should == "SOUTH AUST"
    game.inns1.runs.should == 165
    game.inns1.wickets.should == 4
  end


  private

  def fixture(number)
    file = File.join(FIXTURE_PATH, "Scores#{number}.html")
    raise "fixture #{file} not found" unless File.exist?(file)
    File.read(file)
  end

end
