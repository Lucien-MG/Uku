struct WindyGridworld
    size::Tuple{Int64, Int64}

    player_start_pos::Array{Int64}
    player_position::Array{Int64}

    grid::Matrix{Int8}

    function WindyGridworld()
        size = (7, 10)
        player_start_pos = [4, 1]

        grid = zeros(Int8, size[1], size[2])
        grid[player_start_pos[1], player_start_pos[2]] = 1

        return new(size, player_start_pos, player_start_pos, grid)
    end
end

function step(windygridworld::WindyGridworld, action::Vector{Float64})
    new_pos_x = windygridworld.player_position[1] - action[1] + action[2]
    new_pos_y = windygridworld.player_position[2] + action[3] - action[4]

    if new_pos_x < 1 || new_pos_x > windygridworld.size[1]
        return windygridworld.grid, -1.0, false
    end

    if new_pos_y < 1 || new_pos_y > windygridworld.size[2]
        return windygridworld.grid, -1.0, false
    end

    windygridworld.grid[windygridworld.player_position[1], windygridworld.player_position[2]] = 0

    windygridworld.player_position[1] = new_pos_x
    windygridworld.player_position[2] = new_pos_y

    windygridworld.grid[windygridworld.player_position[1], windygridworld.player_position[2]] = 1

    finished = windygridworld.grid[end, end] == 1

    if finished
        reward = 1.0
    else
        reward = -1.0
    end

    return windygridworld.grid, reward, finished
end

function reset(windygridworld::WindyGridworld)
    windygridworld.grid .= zeros(windygridworld.size[1], windygridworld.size[2])
    windygridworld.grid[windygridworld.player_start_pos[1], windygridworld.player_start_pos[2]] = 1
    windygridworld.player_position .= windygridworld.player_start_pos

    return windygridworld.grid
end
