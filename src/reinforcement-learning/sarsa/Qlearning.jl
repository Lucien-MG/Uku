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

function policy(qlearning::Qlearning, state::Matrix, intern=false)
    hash_state = join(string.(state))

    if !haskey(qlearning.policy, hash_state)
        qlearning.policy[hash_state] = zeros(Float64, qlearning.nb_actions)
    end

    if rand(0.:0.001:1., 1, 1)[end] <= qlearning.epsilon
        action = rand(1:qlearning.nb_actions)[end]
    else
        action = argmax(qlearning.policy[hash_state])
    end

    actions = [0., 0., 0., 0.]
    actions[action] = 1.0

    return actions
end

function learn(qlearning::Qlearning, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    hash_state = join(string.(state))
    hash_state_prime = join(string.(state_prime))

    if !haskey(qlearning.policy, hash_state_prime)
        qlearning.policy[hash_state_prime] = zeros(Float64, qlearning.nb_actions)
    end

    action_index = argmax(action)
    action_index_prime = argmax(qlearning.policy[hash_state_prime])

    qlearning.policy[hash_state][action_index] += qlearning.alpha * (reward + (qlearning.gamma * qlearning.policy[hash_state_prime][action_index_prime]) - qlearning.policy[hash_state][action_index])
end

function reset(qlearning::Qlearning)
end
