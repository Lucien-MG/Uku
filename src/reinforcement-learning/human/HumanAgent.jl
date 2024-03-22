struct HumanAgent
    function HumanAgent()
        return new()
    end
end

function policy(HumanAgent::HumanAgent, state::Matrix{Int8})
    for i = 1:size(state, 1)
        println(state[i, :])
    end

    action_input_line = readline()
    action_array = map(x -> parse(Float64, x), split(action_input_line))
    return action_array
end

function learn(HumanAgent::HumanAgent, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    println("reward: ", reward)
end

function reset(HumanAgent::HumanAgent)
end
