struct EGreedy
    epsilon
    alpha

    q_values

    EGreedy(epsilon, alpha, nb_actions) = new(epsilon, alpha, zeros(nb_actions))
end

function policy(egreedy:: EGreedy)
    if egreedy.epsilon >= rand(Float32, 1)[end]
        action = rand(1:size(egreedy.q_values, 1))[end]
    else
        action = argmax(egreedy.q_values)
    end

    return action
end

function learn(egreedy:: EGreedy, action:: Int, reward:: Float64)
    egreedy.q_values[action] += (reward - egreedy.q_values[action]) * egreedy.alpha
end