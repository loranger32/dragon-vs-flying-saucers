class HighScores
  RANKS = ["Top", "2nd", "3rd", "4th", "5th"]

  def self.load(args, file)
    records = []
    raw = args.gtk.read_file(HIGH_SCORE_FILE)

    raw.each_line do |line|
      score, date_in_seconds = line.split
      records << ScoreRecord.new(score.to_i, date_in_seconds.to_i)
    end

    new(records)
  end

  def self.reset!
    $gtk.args.gtk.delete_file_if_exist(HIGH_SCORE_FILE)
  end

  # scores = []
  def initialize(scores)
    @scores = scores
    @scores.sort!
  end

  # score = int
  def add!(score)
    new_hs = ScoreRecord.new(score, Time.now.to_i)

    sort!.pop if @scores.size >= 5

    @scores << new_hs
    @scores.sort!
  end

  # new_score = int
  def new_high_score?(new_score)
    return true if @scores.size < 5
    @scores.map(&:score).min < new_score
  end

  # new_score = int
  def new_hs_msg(new_score)
    pos = sort!.map(&:score).index(new_score)
    "New High Score - #{RANKS[pos]} rank !"
  end

  def label_current_score(args)
    text = args.state.high_score_saved ? new_hs_msg(args.state.score) : "No New High Score"
    size_enum = 10 
    string_w, _ = args.gtk.calcstringbox(text, size_enum)
    x = (args.grid.w / 2) - (string_w / 2)
    y = 500

    {x: x, y: y, text: text, size_enum: size_enum, r: 255, g: 255, b: 255}
  end

  def label_all_high_score(args)
    max_character_length = 30
    size_enum = 4
    splitted = args.string.wrapped_lines(self.to_s, max_character_length)
    
    splitted.map_with_index do |s, i|
      string_w, _ = args.gtk.calcstringbox(s, size_enum)
      x = (args.grid.w / 2) - (string_w / 2) 
      { x: x, y: 390 - (i * 40), text: s, size_enum: size_enum, r: 255, g: 255, b: 255}
    end
  end

  def save!(args, file)
    add!(args.state.score)
    args.gtk.write_file(file, self.to_save_format)
    args.state.high_score_saved = true
  end

  def sort!
    @scores = @scores.sort_by(&:score).reverse
  end

  def to_s
    sort!.reduce("") { |str, score| str + "#{sprintf("%-3d", score.score)} - #{score.date}\n"}.chomp
  end

  def to_save_format
    sort!.reduce("") { |str, score| str + "#{score.score} #{score.date_in_seconds}\n" }
  end

  class ScoreRecord
    include Comparable

    attr_reader :score

    # score = int, date = int
    def initialize(score, date)
      @score = score
      @date = date
    end

    def date
      full = Time.at(@date.to_i).asctime
      # format = 22 Mar 2023 - 21:41:32
      full[8..9] + " " + full[4..6] + " " + full[-4..-1] + " - " + full[11..18]
    end

    def date_in_seconds
      @date
    end

    def <=>(other)
      score <=> other.score
    end

    def to_s
      "#{@score} points - #{@date}"
    end
  end
end
