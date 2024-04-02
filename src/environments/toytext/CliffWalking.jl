struct CliffWalking
    size::Tuple{Int64, Int64}

    player_position::Array{Int64}
    grid::Matrix{Int8}

    function CliffWalking()
        size = (4, 12)
        player_position = [4, 1]

        grid = zeros(Int8, size[1], size[2])
        grid[4, 1] = 1

        return new(size, player_position, grid)
    end
end

function step(cliffwalking::CliffWalking, action::Vector{Float64})
    new_pos_x = cliffwalking.player_position[1] - action[1] + action[2]
    new_pos_y = cliffwalking.player_position[2] + action[3] - action[4]

    # Check valid position
    if new_pos_x < 1 || new_pos_x > cliffwalking.size[1] || new_pos_y < 1 || new_pos_y > cliffwalking.size[2]
        return cliffwalking.grid, -1.0, false
    end

    # Set new player position
    cliffwalking.grid[cliffwalking.player_position[1], cliffwalking.player_position[2]] = 0

    cliffwalking.player_position[1], cliffwalking.player_position[2] = new_pos_x, new_pos_y

    # Check if the player fall from the cliff
    if cliffwalking.player_position[1] == 4 && (cliffwalking.player_position[2] > 1 && cliffwalking.player_position[2] < cliffwalking.size[2])
        return cliffwalking.grid, -100.0, true
    end

    cliffwalking.grid[cliffwalking.player_position[1], cliffwalking.player_position[2]] = 1

    # Check if the env is finished
    finished = cliffwalking.grid[end, end] == 1

    if finished
        reward = 1.0
    else
        reward = -1.0
    end

    return cliffwalking.grid, reward, finished
end

function reset(cliffwalking::CliffWalking)
    cliffwalking.grid .= zeros(cliffwalking.size[1], cliffwalking.size[2])
    cliffwalking.grid[4, 1] = 1

    cliffwalking.player_position[1] = 4
    cliffwalking.player_position[2] = 1

    return cliffwalking.grid
end
