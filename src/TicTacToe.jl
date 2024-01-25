using LinearAlgebra

mutable struct TicTacToe
    board_free

    board_x
    board_o

    turn

    TicTacToe() = new([1 1 1; 1 1 1; 1 1 1], [0 0 0; 0 0 0; 0 0 0], [0 0 0; 0 0 0; 0 0 0], 0)
end

function play!(tictactoe:: TicTacToe, move:: Matrix{Int64})
    #tictactoe.board_x .= tictactoe.board_free .* (move .* tictactoe.turn_x) 
    #tictactoe.board_o .= tictactoe.board_free .* (move .* tictactoe.turn_x)
    broadcast!(*, tictactoe.board_x, tictactoe.board_free, move, tictactoe.turn)
    broadcast!(*, tictactoe.board_o, tictactoe.board_free, move, tictactoe.turn)

    #tictactoe.board_free .-= move
    broadcast!(-, tictactoe.board_free, move)

    # tictactoe.turn = tictactoe.turn + 1
    return nothing
end

function plot(tictactoe:: TicTacToe)
    println(tictactoe)
end
