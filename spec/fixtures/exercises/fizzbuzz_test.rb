class FizzBuzzTest < Minitest::Test
  def test_returns_number_as_string_when_not_divisible_by_3_or_5
    assert_equal "1", fizzbuzz(1)
  end

  def test_returns_fizz_when_divisible_by_3
    assert_equal "Fizz", fizzbuzz(3)
  end

  def test_returns_buzz_when_divisible_by_5
    assert_equal "Buzz", fizzbuzz(5)
  end

  def test_returns_fizzbuzz_when_divisible_by_3_and_5
    assert_equal "FizzBuzz", fizzbuzz(15)
  end
end
