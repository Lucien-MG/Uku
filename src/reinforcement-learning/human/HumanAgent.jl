struct HumanAgent
    function HumanAgent()
        return new()
    end
end

function policy(HumanAgent::HumanAgent, state::Matrix{Int8})
    println(state)

    action_input_line = readline()
    action_array = map(x -> parse(Float64, x), split(action_input_line))
    return action_array
end

function learn(HumanAgent::HumanAgent, action::Vector{Float64}, reward::Float64)
    println(reward)
end

function reset_agent(HumanAgent::HumanAgent)
end
