module Uku

using Profile

using DelimitedFiles

include("environments/KarmedBandit.jl")
include("environments/KarmedBanditNonStationary.jl")

include("reinforcement-learning/EGreedy.jl")

function play_env(env, agent, nb_steps, mean_rewards::Array{Float64}, optimal_moves::Array{Float64})
    reset_agent(agent)
    reset_env(env)

    for i=1:nb_steps
        action = policy(agent)
        reward = step(env, action)

        learn(agent, action, reward)

        mean_rewards[i] += reward::Float64
        optimal_moves[i] += (action == argmax(env.q_values))::Bool
    end
end

function testbed_karmed(env, agent, nb_runs, nb_steps)
    mean_rewards = zeros(nb_steps)
    optimal_moves = zeros(nb_steps)

    for i=1:nb_runs
        play_env(env, agent, nb_steps, mean_rewards, optimal_moves)
    end

    mean_rewards .= mean_rewards ./ nb_runs
    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return mean_rewards, optimal_moves
end

function run_testbed_experiments()
    nb_runs = 2000
    nb_steps = 10000

    task_1 = Threads.@spawn testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), nb_runs, nb_steps)
    task_2 = Threads.@spawn testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.01, 0.1, 10), nb_runs, nb_steps)
    task_3 = Threads.@spawn testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.0, 0.1, 10), nb_runs, nb_steps)
    task_4 = Threads.@spawn testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.05, 0.1, 10), nb_runs, nb_steps)

    rewards_1, optimal_moves_1 = fetch(task_1)
    rewards_2, optimal_moves_2 = fetch(task_2)
    rewards_3, optimal_moves_3 = fetch(task_3)
    rewards_4, optimal_moves_4 = fetch(task_4)

    open("data/rewards.csv", "w") do io
        write(io, "epsilon-0.1\tepsilon-0.01\tepsilon-0.0\n")
    end

    open("data/rewards.csv", "a") do io
        writedlm(io, hcat(rewards_1, rewards_2, rewards_3))
    end

    open("data/optimal_actions.csv", "w") do io
        write(io, "epsilon-0.1\tepsilon-0.01\tepsilon-0.0\n")
    end

    open("data/optimal_actions.csv", "a") do io
        writedlm(io, hcat(optimal_moves_1, optimal_moves_2, optimal_moves_3))
    end
end

run_testbed_experiments()
# testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), 10, 10)

end # module Uku
