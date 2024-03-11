struct Gridworld
    size::Int64

    player_position::Tuple{Int64, Int64}
    grid::Matrix{Int8}

    Gridworld(size) = new(size, (0, 0), zeros(size[1], size[2]))
end

function step(gridworld::Gridworld, action::Array{Int8})
    gridworld.grid[player_position[1], player_position[2]] = 0

    player_position[1] += action[1] - action[2]
    player_position[2] += action[3] - action[4]

    gridworld.grid[player_position[1], player_position[2]] = 1

    return (gridworld.grid[end, end] == 1) * 2 - 1
end

function is_over()
    return gridworld.grid[end, end] == 1
end

function reset_env(gridworld:: Gridworld)
    gridworld.grid .= zeros(size[1], size[2])
end
