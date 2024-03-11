struct EGreedyMean
    epsilon::Float64

    nb_actions::Int64
    optimistic_initial_value::Float64

    nb_taken_actions::Array{Int64}
    q_values::Array{Float64}

    function EGreedyMean(epsilon, nb_actions, optimistic_initial_value=0)
        return new(epsilon, nb_actions, optimistic_initial_value, ones(nb_actions), ones(nb_actions) * optimistic_initial_value)
    end
end

function policy(egreedy:: EGreedyMean)
    if egreedy.epsilon >= rand(Float64, 1)[end]
        action = rand(1:egreedy.nb_actions)[end]
    else
        action = argmax(egreedy.q_values)
    end

    return action
end

function learn(egreedy::EGreedyMean, action::Int64, reward::Float64)
    egreedy.q_values[action] += (reward - egreedy.q_values[action]) * (1 / egreedy.nb_taken_actions[action])
    egreedy.nb_taken_actions[action] += 1
end

function reset_agent(egreedy:: EGreedyMean)
    egreedy.q_values .= ones(egreedy.nb_actions) * egreedy.optimistic_initial_value
    egreedy.nb_taken_actions .= ones(egreedy.nb_actions)
end
