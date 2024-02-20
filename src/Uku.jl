module Uku

import Base.Threads.@spawn
using DelimitedFiles

include("environments/KarmedBandit.jl")
include("environments/KarmedBanditNonStationary.jl")

include("reinforcement-learning/EGreedy.jl")

function play_karmed(karmedbandit, egreedy, nb_steps)
    all_rewards = Vector{Float64}(undef, nb_steps)
    optimal_moves = Vector{Float64}(undef, nb_steps)

    for i=1:nb_steps
        action = policy(egreedy)

        reward = step(karmedbandit, action)

        learn(egreedy, action, reward)

        all_rewards[i] = reward
        optimal_moves[i] = action == argmax(karmedbandit.q_values)
    end
    
    return all_rewards, optimal_moves
end

function testbed_karmed(nb_runs, nb_steps, epsilon, alpha, nb_actions)
    karmedbandit = KarmedBanditNonStationary()
    egreedy = EGreedy(epsilon, alpha, nb_actions)

    rewards, optimal_moves = play_karmed(karmedbandit, egreedy, nb_steps)

    for i=1:nb_runs
        karmedbandit = KarmedBandit()
        egreedy = EGreedy(epsilon, alpha, nb_actions)

        env_rewards, env_optimal_moves = play_karmed(karmedbandit, egreedy, nb_steps)
        rewards .+= env_rewards
        optimal_moves .+= env_optimal_moves
    end

    # Mean
    rewards .= rewards ./ nb_runs
    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return rewards, optimal_moves
end

function run_experiments()
    nb_runs = 2000
    nb_steps = 10000

    task_1 = Threads.@spawn testbed_karmed(nb_runs, nb_steps, 0.1, 0.1, 10)
    task_2 = Threads.@spawn testbed_karmed(nb_runs, nb_steps, 0.01, 0.1, 10)
    task_3 = Threads.@spawn testbed_karmed(nb_runs, nb_steps, 0.0, 0.1, 10)
    task_4 = Threads.@spawn testbed_karmed(nb_runs, nb_steps, 0.05, 0.1, 10)

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

run_experiments()

end # module Uku
