struct Gridworld
    size::Tuple{Int64, Int64}

    player_position::Array{Int64}
    grid::Matrix{Int8}

    function Gridworld(size)
        grid = zeros(Int8, size[1], size[2])
        grid[1, 1] = 1
        return new(size, [1, 1], grid)
    end
end

function step(gridworld::Gridworld, action::Vector{Float64})
    gridworld.grid[gridworld.player_position[1], gridworld.player_position[2]] = 0

    gridworld.player_position[1] += action[1] - action[2]
    gridworld.player_position[2] += action[3] - action[4]

    gridworld.grid[gridworld.player_position[1], gridworld.player_position[2]] = 1

    finished = gridworld.grid[end, end] == 1
    reward::Float64 = finished * 2 - 1

    return gridworld.grid, reward, finished
end

function reset(gridworld::Gridworld)
    gridworld.grid .= zeros(gridworld.size[1], gridworld.size[2])
    gridworld.grid[1, 1] = 1
    gridworld.player_position[1] = 1
    gridworld.player_position[2] = 1
    return gridworld.grid
end
