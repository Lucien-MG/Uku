struct HumanAgent
    function HumanAgent()
        return new()
    end
end

function policy(HumanAgent::HumanAgent)
    action = readline()
    println(action)

    return action
end

function learn(HumanAgent::HumanAgent, action::Int64, reward::Float64)
end

function reset_agent(HumanAgent::HumanAgent)
end
