module Sky
  def gameplay_sky
    args.outputs.background_color = [92, 120, 230]
  end

  def transition_sky
    args.outputs.solids << [
      [0,   0, args.grid.w, 95,  255, 233, 187],
      [0,  95, args.grid.w, 10,  235, 215, 190],
      [0, 105, args.grid.w, 90,  215, 197, 195],
      [0, 195, args.grid.w, 10,  195, 179, 200],
      [0, 205, args.grid.w, 90,  175, 161, 205],
      [0, 295, args.grid.w, 10,  155, 143, 210],
      [0, 300, args.grid.w, 100, 135, 125, 215],
      [0, 395, args.grid.w, 10,  115, 107, 220],
      [0, 405, args.grid.w, 100, 95, 79, 225],
      [0, 495, args.grid.w, 10,  75, 61, 230],
      [0, 505, args.grid.w, 100, 55, 43, 235],
      [0, 595, args.grid.w, 10,  35, 25, 245],
      [0, 605, args.grid.w, 120, 0, 0, 250]
    ]
  end

  def night_sky
    [[0,   0, args.grid.w, 95,  0, 0, 250],
     [0,  95, args.grid.w, 10,  0, 0, 240],
     [0, 105, args.grid.w, 90,  0, 0, 215],
     [0, 195, args.grid.w, 10,  0, 0, 205],
     [0, 205, args.grid.w, 90,  0, 0, 190],
     [0, 295, args.grid.w, 10,  0, 0, 180],
     [0, 300, args.grid.w, 100, 0, 0, 165],
     [0, 395, args.grid.w, 10,  0, 0, 155],
     [0, 405, args.grid.w, 100, 0, 0, 140],
     [0, 495, args.grid.w, 10,  0, 0, 125],
     [0, 505, args.grid.w, 100, 0, 0, 115],
     [0, 595, args.grid.w, 10,  0, 0, 105],
     [0, 605, args.grid.w, 120, 0, 0, 90]]
  end
end
