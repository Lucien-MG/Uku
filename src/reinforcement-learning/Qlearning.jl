struct Qlearning
    rewards
    action_taken

    Qlearning(nb_actions) = new([10. for i in 1:nb_actions], [1. for i in 1:nb_actions])
end

function action!(qlearning:: Qlearning)
    return argmax(qlearning.rewards ./ qlearning.action_taken)[end]
end

function learn!(qlearning:: Qlearning, action:: Int, reward:: Float64)
    qlearning.rewards[action] += reward
    qlearning.action_taken[action] += 1
end
