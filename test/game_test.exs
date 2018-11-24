defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do

    game = Game.new_game()

    assert game.turn_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state is not changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _ } = Game.make_move(game, "x")
    end
  end

  test "first occurency of letters is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurency of letters is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("chocha")
    { game, _tally } = Game.make_move(game, "o")
    assert game.game_state == :good_guess
    assert game.turn_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("beer")
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turn_left == 7
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :good_guess
    assert game.turn_left == 7
    { game, _tally } = Game.make_move(game, "r")
    assert game.game_state == :won
    assert game.turn_left == 7
  end

  test "bad guess is recognized" do
    game  = Game.new_game("cuca")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turn_left == 6
  end

  test "lost game is recognized" do
    game  = Game.new_game("j")
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turn_left == 6
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turn_left == 5
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turn_left == 4
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turn_left == 3
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turn_left == 2
    { game, _tally } = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turn_left == 1
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :lost
  end
end
