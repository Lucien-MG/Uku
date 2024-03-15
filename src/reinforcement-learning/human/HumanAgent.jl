struct HumanAgent
    function HumanAgent()
        return new()
    end
end

function policy(HumanAgent::HumanAgent, state::Float64)
    println(state)

    action = readline()
    return parse(Int64, action)
end

function learn(HumanAgent::HumanAgent, action::Int64, reward::Float64)
end

function reset_agent(HumanAgent::HumanAgent)
end
