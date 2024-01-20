require_relative '../test_helper'

class OptionalTest < Minitest::Test

  def test_is_present_and_is_empty
    optional = Optional.of(10)
    assert(optional.is_present?)
    assert(!optional.is_empty?)

    optional = Optional.of_nilable(false)
    assert(optional.is_present?)
    assert(!optional.is_empty?)

    optional = Optional.of_nilable(nil)
    assert(!optional.is_present?)
    assert(optional.is_empty?)

    optional = Optional.empty
    assert(!optional.is_present?)
    assert(optional.is_empty?)
  end

  def test_or_else
    optional = Optional.of(10)
    assert_equal(10, optional.or_else(11))

    optional = Optional.of_nilable(false)
    assert(!optional.or_else(true))

    optional = Optional.of_nilable(nil)
    assert_equal(11, optional.or_else(11))

    optional = Optional.empty
    assert_equal(11, optional.or_else(11))
  end

  def test_or_else_get
    optional = Optional.of(10)
    assert_equal(10, optional.or_else_get { next 11 })

    optional = Optional.of_nilable(false)
    assert(!optional.or_else_get { next true })

    optional = Optional.of_nilable(nil)
    assert_equal(11, optional.or_else_get { next 11 })

    optional = Optional.empty
    assert_equal(11, optional.or_else_get { next 11 })
  end

  def test_or_else_throw
    optional = Optional.of(10)
    assert_equal(10, optional.or_else_throw)

    optional = Optional.of_nilable(false)
    assert(!optional.or_else_throw)

    optional = Optional.of_nilable(nil)
    assert_raises(NoSuchElementException) do
      optional.or_else_throw
    end

    optional = Optional.empty
    assert_raises(StandardError) do
      optional.or_else_throw do
        raise StandardError
      end
    end
  end

  def test_or
    optional = Optional.of(10)
    assert_equal(Optional.of(10), optional.or { next Optional.of(12) })

    optional = Optional.empty
    assert_equal(Optional.of(12), optional.or { next Optional.of(12) })
  end

  def test_filter
    optional = Optional.of("Let's change it up")
    assert_equal(Optional.empty, optional.filter { |value| next value == "test" })

    optional = Optional.of("test")
    assert_equal(Optional.of("test"), optional.filter { |value| next value == "test" })

    optional = Optional.empty
    assert_equal(Optional.empty, optional.filter { |value| next value == "test" })
  end

  def test_map
    optional = Optional.of("10")
    assert_equal(Optional.of(10), optional.map { |value| next value.to_i })

    optional = Optional.empty
    assert_equal(Optional.empty, optional.map { |value| next value.to_i })
  end

  def test_flat_map
    optional = Optional.of("10")
    assert_equal(Optional.of(10), optional.flat_map { |value| next Optional.of(value.to_i) })

    optional = Optional.empty
    assert_equal(Optional.empty, optional.flat_map { |value| next Optional.of(value.to_i) })
  end

  def test_if_present
    output = 0
    optional = Optional.of(10)
    optional.if_present do |value|
      output = value
    end
    assert_equal(10, output)

    called = false
    optional = Optional.empty
    optional.if_present do |value|
      called = true
    end
    assert(!called)
  end

  def test_if_present_or_else
    output = 0
    optional = Optional.of(10)
    optional.if_present_or_else(proc {|value| output = value}, proc { output = -1 })
    assert_equal(10, output)

    optional = Optional.empty
    optional.if_present_or_else(proc {|value| output = value}, proc { output = -1 })
    assert_equal(-1, output)
  end

  def test_to_s
    assert_equal("Optional: <Empty>", Optional.empty.to_s)
    assert_equal("Optional: \"This is a string\"", Optional.of("This is a string").to_s)
    assert_equal("Optional: :symbol", Optional.of(:symbol).to_s)
    assert_equal("Optional: 10", Optional.of(10).to_s)
  end
end
