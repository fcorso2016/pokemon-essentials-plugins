module Input

  LEFT = :LEFT

  UP = :UP

  RIGHT = :RIGHT

  DOWN = :DOWN

  A = :A

  B = :B

  C = :C

  X = :X

  Y = :Y

  Z = :Z

  L = :L

  R = :R

  SHIFT = :SHIFT

  CTRL = :CTRL

  ALT = :ALT

  F5 = :F5

  F6 = :F6

  F7 = :F7

  F8 = :F8

  F9 = :F9

  module_function

    def update
      fail NotImplementedError
    end

    def press?(sym)
      fail NotImplementedError
    end

    def trigger?(sym)
      fail NotImplementedError
    end

    def repeat?(sym)
      fail NotImplementedError
    end

    def release(sym)
      fail NotImplementedError
    end

    def pressex?(sym)
      fail NotImplementedError
    end

    def triggerex?(sym)
      fail NotImplementedError
    end

    def repeatex?(sym)
      fail NotImplementedError
    end

    def releaseex?(sym)
      fail NotImplementedError
    end

    def dir4
      fail NotImplementedError
    end

    def dir8
      fail NotImplementedError
    end

    def gets
      fail NotImplementedError
    end

    def raw_key_state
      fail NotImplementedError
    end

    def scroll_v
      fail NotImplementedError
    end

    def mouse_x
      fail NotImplementedError
    end

    def mouse_y
      fail NotImplementedError
    end

    def mouse_in_window?
      fail NotImplementedError
    end

    def time?(i)
      fail NotImplementedError
    end


    attr_accessor :text_input
    attr_accessor :clipboard
    attr_accessor :show_cursor

    module Controller

      def connected?
        fail NotImplementedError
      end

      def name
        fail NotImplementedError
      end

      def pressex?(sym)
        fail NotImplementedError
      end

      def triggerex?(sym)
        fail NotImplementedError
      end

      def repeatex?(sym)
        fail NotImplementedError
      end

      def releaseex?(sym)
        fail NotImplementedError
      end

      def power_level
        fail NotImplementedError
      end

      def axes_left
        fail NotImplementedError
      end

      def axes_right
        fail NotImplementedError
      end

      def axes_trigger
        fail NotImplementedError
      end

      def raw_button_states
        fail NotImplementedError
      end

      def raw_axes
        fail NotImplementedError
      end

    end

end
