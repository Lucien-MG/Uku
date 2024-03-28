mutable struct Qlearning
    epsilon::Float64
    alpha::Float64
    gamma::Float64

    nb_actions::Int64

    policy::Dict{String, Array{Float64}}

    function Qlearning(epsilon, alpha, gamma, nb_actions)
        return new(epsilon, alpha, gamma, nb_actions, Dict())
    end
end

function policy(qlearning::Qlearning, state::Matrix)
    hash_state = join(string.(state))

    if rand() <= qlearning.epsilon
        action = rand(1:qlearning.nb_actions)
    else
        q_values_state = get(qlearning.policy, hash_state, zeros(Float64, qlearning.nb_actions))
        action = argmax(q_values_state)
    end

    actions = zeros(Float64, qlearning.nb_actions)
    actions[action] = 1.0

    return actions
end

function learn(qlearning::Qlearning, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    hash_state = join(string.(state))
    hash_state_prime = join(string.(state_prime))

    if !haskey(qlearning.policy, hash_state)
        qlearning.policy[hash_state] = zeros(Float64, qlearning.nb_actions)
    end

    if !haskey(qlearning.policy, hash_state_prime)
        qlearning.policy[hash_state_prime] = zeros(Float64, qlearning.nb_actions)
    end

    action_index = argmax(action)
    action_index_prime = argmax(qlearning.policy[hash_state_prime])

    qlearning.policy[hash_state][action_index] += qlearning.alpha * (reward + (qlearning.gamma * qlearning.policy[hash_state_prime][action_index_prime]) - qlearning.policy[hash_state][action_index])
end
