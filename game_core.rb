module Scripts
  def self.get_scripts(path = "Data/Scripts")
    scripts = []

    files = []
    folders = []
    Dir.foreach(path) do |f|
      next if f == '.' || f == '..'

      if File.directory?(path + "/" + f)
        folders.push(path + "/" + f)
      elsif !(f =~ /999_Main/i)
        files.push(path + "/" + f)
      end
    end
    files.sort!
    files.each do |f|
      scripts.push(f)
    end

    folders.sort!
    folders.each do |f|
      scripts += get_scripts(f)
    end

    return scripts
  end

  def self.load_scripts
    scripts = get_scripts
    scripts.each do |scr|
      require_relative scr
    end
  end
end

require "mkxp-z"
$show_window = true if $show_window.nil?
$game_state = GameState.new("Pokemon Essentials", ["debug"], $show_window)

alias native_load_data load_data
def load_data(filename, restore = true)
  ret = native_load_data(filename)
  if ret.nil?
    raise sprintf("Failed to load file: %s/%s", Dir.getwd, filename)
  end

  return ret
end

Scripts.load_scripts

module PluginManager
  def self.listAll
    # get a list of all directories in the `Plugins/` folder
    dirs = []
    Dir.get("Plugins").each { |d| dirs.push(d) if Dir.safe?(d) }
    # return all plugins
    return dirs
  end

  def self.runPlugins
    order, plugins = self.getPluginOrder
    Console.echo_li("Loading plugin scripts...")

    # go through the entire order one by one
    order.each do |o|
      # save name, metadata and scripts array
      meta = plugins[o].clone
      meta.delete(:scripts)
      meta.delete(:dir)
      # iterate through each file to deflate
      plugins[o][:scripts].each do |file|
        require_relative "#{plugins[o][:dir]}/#{file}"
      end
    end
  end
end

$RGSS_SCRIPTS = load_data("Data/Scripts.rxdata")