defmodule TooTest do
  use ExUnit.Case
  doctest Too

  test "greets the world" do
    assert Too.hello() == :world
  end
end
