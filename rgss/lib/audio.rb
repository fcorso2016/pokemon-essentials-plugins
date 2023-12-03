module Audio
  class << self

    def setup_midi
      fail NotImplementedError
    end

    def bgm_play(filename, volume = nil, pitch = nil, pos = nil, track = nil)
      fail NotImplementedError
    end

    def bgm_stop(track = nil)
      fail NotImplementedError
    end

    def bgm_fade(time, track = nil)
      fail NotImplementedError
    end

    def self.bgm_volume(track = nil)
      fail NotImplementedError
    end

    def self.bgm_set_volume(vol, track = nil)
      fail NotImplementedError
    end

    def bgm_pos
      fail NotImplementedError
    end

    def bgs_play(filename, volume = nil, pitch = nil, pos = nil)
      fail NotImplementedError
    end

    def bgs_stop
      fail NotImplementedError
    end

    def bgs_fade(time)
      fail NotImplementedError
    end

    def bgs_pos
      fail NotImplementedError
    end

    def me_play(filename, volume = nil, pitch = nil)
      fail NotImplementedError
    end

    def me_stop
      fail NotImplementedError
    end

    def me_fade(time)
      fail NotImplementedError
    end

    def se_play(filename, volume = nil, pitch = nil)
      fail NotImplementedError
    end

    def se_stop
      fail NotImplementedError
    end

  end
end
