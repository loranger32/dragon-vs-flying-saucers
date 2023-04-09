FPS = 60
SCENE_DURATION = 20
HIGH_SCORE_FILE = "high-score.txt"
GAME_OVER_SCENE = GameOver
TITLE_SCENE = Title
PAUSE_SCENE = Pause
CREDIT_SCENE = Credits
LEVEL_ONE_SCENE = LevelOne
LEVEL_TWO_SCENE = LevelTwo
LEVEL_THREE_SCENE = LevelThree
LEVEL_FOUR_SCENE = LevelFour
LEVEL_FIVE_SCENE = LevelFive
FINAL_BOSS_SCENE = FinalLevel
END_GAME_TRANSITION_SCENE = EndGameTransition
LOGO_SCENE = Logo

def tick(args)
  # Hack for broken ~ console key
  if args.inputs.keyboard.key_down.m
    args.gtk.console.show
  end

  args.state.scene ||= LOGO_SCENE.new(args)
  args.state.scene.tick
end

$gtk.reset
