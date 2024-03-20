struct Sarsa
    alpha::Float64
    gamma::Float64

    nb_actions::Int64

    actions::Vector{Vector{Float64}}
    states# ::Vector{string}
    rewards::Vector{Float64}

    policy# ::Dict{string, Array{Float64}}

    function MCFirstVisit(alpha, gamma, nb_actions)
        policy = Dict("" => [0.0, 0.0, 0.0, 0.0])
        return new(alpha, gamma, nb_actions, Vector(), Vector(), Vector{Float64}(), policy)
    end
end

function policy(mc::MCFirstVisit, state::Matrix)
    hash_state = join(string.(state))
    if !haskey(mc.policy, hash_state)
        mc.policy[hash_state] = [1, 1, 1, 1]
    end
    q_values = mc.policy[hash_state]
    actions = [0.0, 0.0, 0.0, 0.0]
    actions[argmax(q_values)] = 1
    return vec(actions)
end

function learn(mc::MCFirstVisit, state::Matrix, action::Vector{Float64}, reward::Float64)
    hash_state = join(string.(state))

    push!(mc.actions, action)
    push!(mc.states, hash_state)
    push!(mc.rewards, reward)
end

function reset(mc::MCFirstVisit)
    if length(mc.rewards) == 0
        return
    end

    last_retro_reward = 0
    println(length(mc.rewards))

    for i in length(mc.rewards):-1:1
        state = mc.states[i]
        action = argmax(mc.actions[i])
        reward = mc.rewards[i]

        retro_reward = reward + mc.gamma * last_retro_reward
        mc.policy[state][action] += mc.alpha * (retro_reward - mc.policy[state][action])

        println(mc.policy[state][action])

        last_retro_reward = retro_reward
    end

    empty!(mc.actions)
    empty!(mc.states)
    empty!(mc.rewards)
end
