module Uku

include("KarmedBandit.jl")
include("TicTacToe.jl")

function random_move(move)
    fill!(move, 0)

    # Generate random indices for the position of the '1'
    row_index = rand(1:3)
    col_index = rand(1:3)

    # Set the chosen position to '1'
    move[row_index, col_index] = 1

    return move
end

function play_tictactoe(game)
    move = zeros(Int, 3, 3)
    for i=1:1000000
        move .= random_move(move)
        play!(game, move)
    end
end

function play_karmed(karmedbandit)
    reward = 0
    for i=1:10000000
        reward = step!(karmedbandit, 1)
    end
end

const game = TicTacToe()

const karmedbandit = KarmedBandit()

@time play_tictactoe(game)
@time play_tictactoe(game)

@time play_karmed(karmedbandit)
@time play_karmed(karmedbandit)

end # module Uku
