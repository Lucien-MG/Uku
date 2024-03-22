mutable struct Sarsa
    epsilon::Float64
    alpha::Float64
    gamma::Float64

    nb_actions::Int64
    action_index_prime::Int64

    policy::Dict{String, Array{Float64}}

    function Sarsa(epsilon, alpha, gamma, nb_actions)
        return new(epsilon, alpha, gamma, nb_actions, rand(1:nb_actions)[end], Dict())
    end
end

function policy(sarsa::Sarsa, state::Matrix, intern=false)
    if !intern
        actions = [0., 0., 0., 0.]
        actions[sarsa.action_index_prime] = 1.0

        return actions
    end

    hash_state = join(string.(state))

    if !haskey(sarsa.policy, hash_state)
        sarsa.policy[hash_state] = zeros(Float64, sarsa.nb_actions)
    end

    if rand(0.:0.001:1., 1, 1)[end] <= sarsa.epsilon
        action = rand(1:sarsa.nb_actions)[end]
    else
        action = argmax(sarsa.policy[hash_state])
    end

    actions = [0., 0., 0., 0.]
    actions[action] = 1.0

    return actions
end

function learn(sarsa::Sarsa, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    hash_state = join(string.(state))
    hash_state_prime = join(string.(state_prime))

    action_index = argmax(action)
    sarsa.action_index_prime = argmax(policy(sarsa, state_prime, true))

    sarsa.policy[hash_state][action_index] += sarsa.alpha * (reward + (sarsa.gamma * sarsa.policy[hash_state_prime][sarsa.action_index_prime]) - sarsa.policy[hash_state][action_index])
end

function reset(sarsa::Sarsa)
end
