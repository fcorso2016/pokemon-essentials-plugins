##
# A container object which may or may not contain a non-null value
class Optional

  ##
  # Returns an Optional describing the given non-null value.
  def self.of(value)
    return self.new(value)
  end

  ##
  # Returns an Optional describing the given value, if non-null, otherwise returns an empty Optional.
  def self.of_nilable(value)
    return self.new(value)
  end

  ##
  # Returns an empty Optional instance.
  def self.empty
    return self.new
  end

  private_class_method :new

  def initialize(value = nil)
    @value = value
  end

  def ==(other)
    return true if is_empty? && other.is_empty?
    return false if is_present? != other.is_present?
    return @value == other.or_else_throw
  end

  def to_s
    case @value
    when nil
      return "Optional: <Empty>"
    when String
      return "Optional: #{@value.to_json}"
    when Symbol
      return "Optional: :#{@value.to_s}"
    else
      return "Optional: #{@value.to_s}"
    end
  end

  ##
  # If a value is present, returns true, otherwise false.
  def is_present?
    return !@value.nil?
  end

  ##
  # If a value is not present, returns true, otherwise false.
  def is_empty?
    return @value.nil?
  end

  ##
  # If a value is present, returns the value, otherwise returns default.
  def or_else(default)
    return @value.nil? ? default : @value
  end

  ##
  # If a value is present, returns the value, otherwise returns the result produced by the supplying block.
  def or_else_get(&default)
    return @value.nil? ? default.call : @value
  end

  ##
  # If a value is present, returns the value, otherwise throws an exception produced by the exception supplying block.
  #
  # If not such block is provided, then throw NoSuchElementException
  def or_else_throw
    return @value unless @value.nil?

    if block_given?
      yield
    else
      raise NoSuchElementException
    end
  end

  ##
  # If a value is present, returns an Optional describing the value, otherwise returns an Optional produced by the
  # supplying block.
  def or
    return self unless @value.nil?
    return yield
  end

  ##
  # If a value is present, and the value matches the given predicate, returns an Optional describing the value,
  # otherwise returns an empty Optional.
  def filter(&predicate)
    return !@value.nil? && predicate.call(@value) ? self : Optional.empty
  end

  ##
  # If a value is present, returns an Optional describing (as if by of_nilable(T)) the result of applying the given
  # mapping function to the value, otherwise returns an empty Optional.
  def map
    return !@value.nil? ? Optional.of_nilable(yield @value) : Optional.empty
  end

  ##
  # If a value is present, returns the result of applying the given Optional-bearing mapping function to the value,
  # otherwise returns an empty Optional.
  def flat_map
    return yield @value unless @value.nil?
    return Optional.empty
  end

  ##
  # If a value is present, performs the given action with the value, otherwise does nothing.
  def if_present
    yield @value unless @value.nil?
  end

  ##
  # If a value is present, performs the given action with the value, otherwise performs the given empty-based action.
  def if_present_or_else(action, empty_action)
    if @value.nil?
      return empty_action.call
    else
      return action.call(@value)
    end
  end

end
