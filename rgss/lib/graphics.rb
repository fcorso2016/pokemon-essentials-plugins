module Graphics
  module_function

  def update
    fail NotImplementedError
  end

  def wait(duration)
    fail NotImplementedError
  end

  def fadeout(duration)
    fail NotImplementedError
  end

  def fadein(duration)
    fail NotImplementedError
  end

  def freeze
    fail NotImplementedError
  end

  def transition(duration = 10, filename = nil, vague = 40)
    fail NotImplementedError
  end

  def snap_to_bitmap
    fail NotImplementedError
  end

  def frame_reset
    fail NotImplementedError
  end

  def width
    fail NotImplementedError
  end

  def height
    fail NotImplementedError
  end

  def resize_screen(width, height)
    fail NotImplementedError
  end

  def play_movie(filename, volume = 100, allow_skipping = false)
    fail NotImplementedError
  end

  def resize_window(width, height, center = false)
    fail NotImplementedError
  end

  def center
    fail NotImplementedError
  end

  def screenshot(path)
    fail NotImplementedError
  end

  def delta
    fail NotImplementedError
  end

  def frame_rate
    fail NotImplementedError
  end

  def frame_rate=(value)
    fail NotImplementedError
  end

  def frame_count
    fail NotImplementedError
  end

  def frame_count=(value)
    fail NotImplementedError
  end

  def brightness
    fail NotImplementedError
  end

  def brightness=(value)
    fail NotImplementedError
  end

  def scale
    fail NotImplementedError
  end

  def scale=(value)
    fail NotImplementedError
  end

  def fixed_aspect_ratio
    fail NotImplementedError
  end

  def fixed_aspect_ratio=(value)
    fail NotImplementedError
  end

  def smooth_scaling
    fail NotImplementedError
  end

  def smooth_scaling=(value)
    fail NotImplementedError
  end

  def integer_scaling
    fail NotImplementedError
  end

  def integer_scaling=(value)
    fail NotImplementedError
  end

  def last_mile_scaling
    fail NotImplementedError
  end

  def last_mile_scaling=(value)
    fail NotImplementedError
  end

  def full_screen
    fail NotImplementedError
  end

  def full_screen=(value)
    fail NotImplementedError
  end

end
