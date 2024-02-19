struct Egreedy
    epsilon
    nb_actions

    action

    q_values
    action_taken

    Egreedy(epsilon, nb_actions) = new(epsilon, nb_actions, 0, zeros(nb_actions), ones(nb_actions))
end

function policy(egreedy:: Egreedy)
    if egreedy.epsilon >= rand(Float32, 1)[end]
        action = rand(1:egreedy.nb_actions)[end]
    else
        action = argmax(egreedy.q_values)[end]
    end

    return action
end

function learn(egreedy:: Egreedy, action:: Int, reward:: Float64)
    egreedy.q_values[action] += (reward - egreedy.q_values[action]) / egreedy.action_taken[action]
    egreedy.action_taken[action] += 1
end
