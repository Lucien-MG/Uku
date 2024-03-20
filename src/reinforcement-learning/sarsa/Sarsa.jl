mutable struct Sarsa
    epsilon::Float64
    alpha::Float64
    gamma::Float64

    nb_actions::Int64
    prev_state::String

    actions::Vector{Vector{Float64}}
    states::Vector{String}
    rewards::Vector{Float64}

    policy::Dict{String, Array{Float64, 1}}

    function Sarsa(epsilon, alpha, gamma, nb_actions)
        return new(epsilon, alpha, gamma, nb_actions, "", Vector(), Vector(), Vector(), Dict())
    end
end

function policy(sarsa::Sarsa, state::Matrix)
    hash_state = join(string.(state))
    sarsa.prev_state = hash_state

    if !haskey(sarsa.policy, hash_state)
        sarsa.policy[hash_state] = ones(Float64, sarsa.nb_actions)
    end

    if rand(Float64, 1)[end] <= sarsa.epsilon
        action = rand(1:sarsa.nb_actions)[end]
    else
        action = argmax(sarsa.policy[hash_state])
    end

    actions = zeros(Float64, sarsa.nb_actions)
    actions[action] = 1

    return vec(actions)
end

function learn(sarsa::Sarsa, state::Matrix, action::Vector{Float64}, reward::Float64)
    hash_state = join(string.(state))
    action_index = argmax(action)
    action_index_prime = argmax(policy(sarsa, state))
    sarsa.policy[sarsa.prev_state][action_index] += sarsa.alpha * (reward + (sarsa.gamma * sarsa.policy[hash_state][action_index_prime]) - sarsa.policy[sarsa.prev_state][action_index])
end

function reset(mc::Sarsa)
end
