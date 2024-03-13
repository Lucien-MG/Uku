struct UCB
    exploration_degree::Float64
    alpha::Float64

    nb_actions::Int64

    action_taken::Array{Int64}
    q_values::Array{Float64}

    function UCB(exploration_degree, alpha, nb_actions)
        return new(exploration_degree, alpha, nb_actions, zeros(nb_actions), zeros(nb_actions))
    end
end

function policy(ucb:: UCB, state::Float64)
    if 0 in ucb.action_taken
        action = findfirst(x -> x==0, ucb.action_taken)
    else
        exploration_state = sqrt.(log(2.71, sum(ucb.action_taken)) ./ ucb.action_taken)
        tmp_q_values = ucb.q_values + ucb.exploration_degree * exploration_state
        action = argmax(tmp_q_values)
    end
    return action
end

function learn(ucb::UCB, action::Int64, reward::Float64)
    ucb.action_taken[action] += 1
    ucb.q_values[action] += ucb.alpha * (reward - ucb.q_values[action])
end

function reset_agent(ucb:: UCB)
    ucb.q_values .= zeros(ucb.nb_actions)
    ucb.action_taken .= zeros(ucb.nb_actions)
end
