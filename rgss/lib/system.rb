module System
  attr_accessor :window_tile

  def self.data_directory
    fail NotImplementedError
  end

  def self.lauch(cmd, args)
    fail NotImplementedError
  end

  def self.user_language
    fail NotImplementedError
  end

  def self.game_tile
    fail NotImplementedError
  end

  def self.show_settings
    fail NotImplementedError
  end

  def self.power_state
    fail NotImplementedError
  end

  def self.uptime
    fail NotImplementedError
  end

  def self.platform
    fail NotImplementedError
  end

  def self.is_windows?
    fail NotImplementedError
  end

  def self.is_mac?
    fail NotImplementedError
  end

  def self.is_linux?
    fail NotImplementedError
  end

  def self.is_rosetta?
    fail NotImplementedError
  end

  def self.is_wine?
    fail NotImplementedError
  end

  def self.is_really_windows?
    fail NotImplementedError
  end

  def self.is_really_mac?
    fail NotImplementedError
  end

  def self.is_really_linux?
    fail NotImplementedError
  end

  def self.desensitize(path)
    fail NotImplementedError
  end

  def self.reload_cache
    fail NotImplementedError
  end

  def self.unmount(path, reload = true)
    fail NotImplementedError
  end

  def self.user_name
    fail NotImplementedError
  end

end
