defmodule VoterTest do
  use ExUnit.Case
  doctest Voter

  test "all 1s" do
    list = [1,1,1]
    assert [1,2,3] == Voter.start(list)
  end

  test "all 0s" do
    list = [0,0,0]
    assert [0,0,0] == Voter.start(list)
  end

  test "all 2s" do
    list = [2,2,2]
    assert [-1,-2,-3] == Voter.start(list)
  end
end
