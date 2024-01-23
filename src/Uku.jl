module Uku

include("TicTacToe.jl")

function play_tictactoe(game, move)
    for i=1:1000000
        play!(game, move)
    end
end

function test2!(a, b)
    a .-= a .* b .* b .* b .* 1
end

function test(a, b)
    for i=1:100000
        test2!(a, b)
    end
end

const game = TicTacToe()
const move = [0 0 0; 0 1 0; 0 0 0]

@time play_tictactoe(game, move)
@time play_tictactoe(game, move)

a = [0 0 0; 0 0 0; 0 0 0]
b = [0 0 0; 0 0 0; 0 0 0]

@time test(a, b)
@time test(a, b)

@time test2!(a, b)
@time test2!(a, b)

end # module Uku
