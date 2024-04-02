struct HumanAgent
    function HumanAgent()
        return new()
    end
end

function policy(HumanAgent::HumanAgent, state::Matrix{Int8})
    println("state:")

    for i = 1:size(state, 1)
        println(state[i, :])
    end

    print("action: ")

    action_input_line = readline()
    action_array = map(x -> parse(Float64, x), split(action_input_line))

    return action_array
end

function learn(HumanAgent::HumanAgent, state::Matrix, state_prime::Matrix, action::Array{Float64}, reward::Float64)
    println("new state:")

    for i = 1:size(state_prime, 1)
        println(state_prime[i, :])
    end

    println("reward: ", reward)
end
