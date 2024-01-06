# frozen_string_literal: true

class Optional

  def self.of(value)
    return Optional.new(value)
  end

  def self.of_nilable(value)
    return Optional.new(value)
  end

  def self.empty
    return Optional.new
  end

  private_class_method :new

  def initialize(value = nil)
    @value = nil
  end

  def is_present?
    return !@value.nil?
  end

  def or_else(default)
    return @value.nil? ? default : @value
  end

  def or_else_get(&default)
    return @value.nil? ? default.call : @value
  end

  def or_else_throw
    return @value unless @value.nil?

    if block_given?
      yield
    else
      raise NoSuchElementException
    end
  end

  def or
    return self unless @value.nil?
    return yield
  end

  def filter(&predicate)
    return !@value.nil? && predicate.call(get) ? @value : Optional.empty
  end

  def map
    return @value.nil? ? Optional.of_nilable(yield @value) : Optional.empty
  end

  def if_present
    yield @value unless @value.nil?
  end

  def if_present_or_else(action, empty_action)
    unless @value.nil?
      return action.call(@value)
    else
      return empty_action.call
    end
  end

end
