module Uku

include("KarmedBandit.jl")
include("reinforcement-learning/Qlearning.jl")
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

function play_karmed(karmedbandit, qlearning)
    action = 0
    reward = 0
    for i=1:1000000
        action = action!(qlearning)
        reward = step!(karmedbandit, action)

        learn!(qlearning, action, reward)
    end
    print(qlearning)
end

const game = TicTacToe()

const karmedbandit = KarmedBandit()
const qlearning = Qlearning(10)

@time play_tictactoe(game)
@time play_tictactoe(game)

@time play_karmed(karmedbandit, qlearning)
@time play_karmed(karmedbandit, qlearning)

end # module Uku
