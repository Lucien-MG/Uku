
struct TicTacToe
    board_taken

    board_x
    board_o

    turn_x
    turn_o

    TicTacToe() = new([1 1 1; 1 1 1; 1 1 1], [0 0 0; 0 0 0; 0 0 0], [0 0 0; 0 0 0; 0 0 0], 1, 0)
end

function play!(tictactoe:: TicTacToe, move:: Matrix{Int64})
    #(move .* tictactoe.turn_x) 
    #tictactoe.board_x .= tictactoe.board_taken #.* (move .* tictactoe.turn_x) 
    #tictactoe.board_o .= tictactoe.board_taken #.* (move .* tictactoe.turn_o)

    tictactoe.board_taken .-= tictactoe.board_taken #.* move

    #tictactoe.turn_x = (tictactoe.turn_x + 1) % 2
    #tictactoe.turn_o = (tictactoe.turn_o + 1) % 2
    return nothing
end

function plot(tictactoe:: TicTacToe)
    println(tictactoe)
end
