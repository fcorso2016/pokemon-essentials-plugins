module Graphics
  class << self

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

    attr_accessor :frame_rate
    attr_accessor :frame_count
    attr_accessor :brightness
    attr_accessor :scale
    attr_accessor :fixed_aspect_ratio
    attr_accessor :smooth_scaling
    attr_accessor :integer_scaling
    attr_accessor :last_mile_scaling

  end
end
