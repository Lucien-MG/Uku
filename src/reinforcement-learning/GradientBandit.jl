struct GradientBandit
    alpha::Float64
    nb_actions::Int64

    numerical_preferences::Array{Float64}
    pi::Array{Float64}
    average_rewards::Array{Float64}

    function GradientBandit(alpha, nb_actions)
        return new(alpha, nb_actions, randn(nb_actions), zeros(nb_actions), zeros(nb_actions))
    end
end

function softmax(numerical_preferences::Array{Float64})
    return exp.(numerical_preferences) / sum(exp.(numerical_preferences))
end

function sample(weights::Array{Float64})
    res = zeros(Int64, size(weights)[end])

    for i in 1:size(weights)[end]
        res[i] = rand(1:trunc(Int, weights[i] * 10000 + 1))
    end

    return res
end

function policy(gb::GradientBandit)
    gb.pi .= softmax(gb.numerical_preferences)
    action = argmax(sample(gb.pi))

    return action
end

function learn(gb::GradientBandit, action::Int64, reward::Float64)
    gb.average_rewards[action] += gb.alpha * (reward - gb.average_rewards[action])

    gb.numerical_preferences[action] += gb.alpha * (reward - gb.average_rewards[action]) * (1 - gb.pi[action])

    tmp = gb.numerical_preferences[action]
    gb.numerical_preferences .-= gb.alpha * (reward .- gb.average_rewards) .* gb.pi
    gb.numerical_preferences[action] = tmp
end

function reset_agent(gb::GradientBandit)
    gb.numerical_preferences .= zeros(gb.nb_actions)
    gb.average_rewards .= zeros(gb.nb_actions)
end
