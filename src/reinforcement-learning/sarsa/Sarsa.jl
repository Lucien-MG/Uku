mutable struct Sarsa
    epsilon::Float64
    alpha::Float64
    gamma::Float64

    nb_actions::Int64

    policy::Dict{String, Array{Float64}}

    function Sarsa(epsilon, alpha, gamma, nb_actions)
        return new(epsilon, alpha, gamma, nb_actions, Dict())
    end
end

function policy(sarsa::Sarsa, state::Matrix)
    hash_state = join(string.(state))
    println(hash_state)

    if !haskey(sarsa.policy, hash_state)
        sarsa.policy[hash_state] = zeros(Float64, sarsa.nb_actions)
    end

    if rand(Float64, 1)[end] <= sarsa.epsilon
        action = rand(1:sarsa.nb_actions)[end]
    else
        action = argmax(sarsa.policy[hash_state])
        println(sarsa.policy[hash_state])
    end
    println(action)

    actions = [0., 0., 0., 0.]
    actions[action] = 1.0

    return actions
end

function learn(sarsa::Sarsa, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    hash_state = join(string.(state))
    hash_state_prime = join(string.(state_prime))

    action_index = argmax(action)
    action_index_prime = argmax(policy(sarsa, state_prime))

    sarsa.policy[hash_state][action_index] += sarsa.alpha * (reward + (sarsa.gamma * sarsa.policy[hash_state_prime][action_index_prime]) - sarsa.policy[hash_state][action_index])
end

function reset(mc::Sarsa)
end
