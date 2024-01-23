module Uku

include("TicTacToe.jl")

function play_tictactoe(game, move)
    for i=1:1000000
        play!(game, move)
    end
end

function test2!(a:: Matrix{Int64}, b:: Matrix{Int64})
    a .* b .* b .* b .* 1
end

function test()
    a = [0 0 0; 0 0 0; 0 0 0]
    b = [0 0 0; 0 0 0; 0 0 0]
    for i=1:1000000
        a .-= test2!(a,b)
    end
end

const game = TicTacToe()
move = [0 0 0; 0 1 0; 0 0 0]

@time play_tictactoe(game, move)
@time play_tictactoe(game, move)

@time test()
@time test()

end # module Uku
