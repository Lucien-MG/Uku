struct EGreedy
    epsilon::Float64
    alpha::Float64

    nb_actions::Int64
    optimistic_initial_value::Float64

    q_values::Array{Float64}

    function EGreedy(epsilon, alpha, nb_actions, optimistic_initial_value=0)
        return new(epsilon, alpha, nb_actions, optimistic_initial_value, ones(nb_actions) * optimistic_initial_value)
    end
end

function policy(egreedy:: EGreedy, statestate::Float64)
    if egreedy.epsilon >= rand(Float64, 1)[end]
        action = rand(1:size(egreedy.q_values, 1))[end]
    else
        action = argmax(egreedy.q_values)
    end

    return action
end

function learn(egreedy::EGreedy, action::Int64, reward::Float64)
    egreedy.q_values[action] += egreedy.alpha * (reward - egreedy.q_values[action])
end

function reset_agent(egreedy:: EGreedy)
    egreedy.q_values .= ones(egreedy.nb_actions) * egreedy.optimistic_initial_value
end
