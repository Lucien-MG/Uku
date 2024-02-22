struct EGreedyUCB
    exploration_degree::Float64
    alpha::Float64

    nb_actions::Int64
    optimistic_initial_value::Float64

    action_taken::Array{Int64}
    q_values::Array{Float64}

    function EGreedyUCB(exploration_degree, alpha, nb_actions, optimistic_initial_value=0)
        return new(exploration_degree, alpha, nb_actions, optimistic_initial_value, ones(nb_actions), ones(nb_actions) * optimistic_initial_value)
    end
end

function policy(egreedy:: EGreedyUCB)
    action = argmax(egreedy.q_values + egreedy.exploration_degree * sqrt.(log2(sum(egreedy.action_taken)) ./ egreedy.action_taken))
    return action
end

function learn(egreedy::EGreedyUCB, action::Int64, reward::Float64)
    egreedy.q_values[action] += egreedy.alpha * (reward - egreedy.q_values[action])
    egreedy.action_taken[action] += 1
end

function reset_agent(egreedy:: EGreedyUCB)
    egreedy.q_values .= ones(egreedy.nb_actions) * egreedy.optimistic_initial_value
end
