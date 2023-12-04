class Bitmap

  def self.max_size
    fail NotImplementedError
  end

  def initialize(arg1, height = nil)
    fail NotImplementedError
  end

  def dispose
    fail NotImplementedError
  end

  def disposed?
    fail NotImplementedError
  end

  def width
    fail NotImplementedError
  end

  def height
    fail NotImplementedError
  end

  def rect
    fail NotImplementedError
  end

  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    fail NotImplementedError
  end

  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    fail NotImplementedError
  end

  def fill_rect(arg1, arg2,width = nil, height = nil, color = nil)
    fail NotImplementedError
  end

  def gradient_fill_rect(arg1, arg2, arg3, arg4 = nil, arg5 = nil, arg6 = nil)
    fail NotImplementedError
  end

  def clear
    fail NotImplementedError
  end

  def clear_rect(arg1, y = 0, width = nil, height = nil)
    fail NotImplementedError
  end

  def get_pixel(x, y)
    fail NotImplementedError
  end

  def set_pixel(x, y, color)
    fail NotImplementedError
  end

  def hue_change(hue)
    fail NotImplementedError
  end

  def blur
    fail NotImplementedError
  end

  def radial_blur(angle, division)
    fail NotImplementedError
  end

  def draw_text(arg1, arg2, arg3, height = nil, arg5 = nil, arg6 = nil)
    fail NotImplementedError
  end

  def text_size(str)
    fail NotImplementedError
  end

  def mega?
    fail NotImplementedError
  end

  def to_file(path)
    fail NotImplementedError
  end

  def animated?
    fail NotImplementedError
  end

  def current_frame
    fail NotImplementedError
  end

  def frame_count
    fail NotImplementedError
  end


  def play
    fail NotImplementedError
  end

  def stop
    fail NotImplementedError
  end

  def goto_and_play(pos)
    fail NotImplementedError
  end

  def goto_and_stop(pos)
    fail NotImplementedError
  end

  def next_frame
    fail NotImplementedError
  end

  def previous_frame
    fail NotImplementedError
  end

  def add_frame(source, position = -1)
    fail NotImplementedError
  end

  def remove_frame(position = 0)
    fail NotImplementedError
  end

  def snap_to_bitmap(position = 0)
    fail NotImplementedError
  end

  attr_accessor :font
  attr_accessor :raw_data
  attr_accessor :playing
  attr_accessor :looping
  attr_accessor :frame_rate

end
