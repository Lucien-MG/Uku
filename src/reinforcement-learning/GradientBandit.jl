struct GradientBandit
    alpha::Float64
    nb_actions::Int64

    random_number_generated::Array{Int64}
    numerical_preference::Array{Float64}

    function GradientBandit(alpha, nb_actions)
        return new(alpha, nb_actions, zeros(1), randn(nb_actions))
    end
end

function soft-max(numerical_preference::Array{Float64})
    return exp(numerical_preference) / sum(exp(numerical_preference))
end

function policy(egreedy:: GradientBandit)
    rand!(1:10000, random_number_generated)

    pi = soft-max(egreedy.numerical_preference)

    action = 0
    return action
end

function learn(egreedy::GradientBandit, action::Int64, reward::Float64)
    egreedy.q_values[action] += egreedy.alpha * (reward - egreedy.q_values[action])
end

function reset_agent(egreedy:: GradientBandit)
    egreedy.q_values .= ones(egreedy.nb_actions) * egreedy.optimistic_initial_value
end
