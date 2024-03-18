module Uku

using DelimitedFiles

# Envs
include("environments/karmedbandit/KArmedBandit.jl")
include("environments/karmedbandit/KarmedBanditNonStationary.jl")
include("environments/2dboardgame/Gridworld.jl")

# Agents
include("reinforcement-learning/tabular/EGreedy.jl")
include("reinforcement-learning/tabular/EGreedyMean.jl")
include("reinforcement-learning/tabular/GradientBandit.jl")
include("reinforcement-learning/tabular/UCB.jl")
include("reinforcement-learning/tabular/UCBMean.jl")

include("reinforcement-learning/montecarlo/MCFirstVisit.jl")

include("reinforcement-learning/human/HumanAgent.jl")

function play_env(env, agent, nb_steps, mean_rewards::Vector{Float64}, optimal_moves::Array{Float64})
    reset(agent)
    state = reset(env)

    finished = false

    while !finished
        action = policy(agent, state)

        state, reward, finished = step(env, action)

        learn(agent, state, action, reward)

        push!(mean_rewards, reward)
        # optimal_moves[i] += (action == argmax(env.expected_rewards))::Bool
    end
end

function testbed_karmed(name, env, agent, nb_runs, nb_steps)
    mean_rewards = Vector{Float64}() # zeros(nb_steps)
    optimal_moves = zeros(nb_steps)

    for i=1:nb_runs
        play_env(env, agent, nb_steps, mean_rewards, optimal_moves)
    end

    mean_rewards .= mean_rewards ./ nb_runs
    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return name, mean_rewards, optimal_moves
end

function save_experiences(results_exps)
    open("data/rewards.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/rewards.csv", "a") do io
        writedlm(io, hcat([results_exps[i][2] for i=1:length(results_exps)]...))
    end

    open("data/optimal_actions.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/optimal_actions.csv", "a") do io
        writedlm(io, hcat([results_exps[i][3] for i=1:length(results_exps)]...))
    end
end

function run_testbed_experiments(nb_runs, nb_steps, experiences)
    running_exps = []

    Threads.@threads for i in 1:length(experiences)
        thread = testbed_karmed(experiences[i][1], experiences[i][2], experiences[i][3], nb_runs, nb_steps)
        push!(running_exps, thread)
    end

    results_exps = [fetch(running_exps[i]) for i=1:length(running_exps)]

    save_experiences(results_exps)
end

function generate_parameters_study(name, env, agent, parameters)
    experiences = []

    for i in 1:length(parameters)
        exp = (name * string(parameters[i]), KarmedBandit(10), agent(parameters[i], 0.1, 10, 4))
        push!(experiences, exp)
    end

    return experiences
end

nb_actions = 10
nb_runs = 3
nb_steps = 1000

# experiences = [
#         ("epsilon-0.0", KArmedBandit(nb_actions), EGreedyMean(0, nb_actions)),
#         ("epsilon-0.0-optimistic", KArmedBandit(nb_actions), EGreedy(0, 0.1, nb_actions, 5)),
#         ("epsilon-0.1-mean", KArmedBandit(nb_actions), EGreedyMean(0.1, nb_actions)),
#         ("epsilon-0.1-alpha", KArmedBandit(nb_actions), EGreedy(0.1, 0.15, nb_actions)),
#         ("epsilon-0.01-mean", KArmedBandit(nb_actions), EGreedyMean(0.01, nb_actions)),
#         ("epsilon-0.01-alpha", KArmedBandit(nb_actions), EGreedy(0.01, 0.15, nb_actions)),
#         ("ucb-c_2-alpha_0.1", KArmedBandit(nb_actions), UCB(2, 0.1, nb_actions)),
#         ("ucb-mean-c_2", KArmedBandit(nb_actions), UCBMean(2, nb_actions)),
#         ("gradientbandit-0.1", KArmedBandit(nb_actions), GradientBandit(0.01, nb_actions)),
# ]

# experiences = [
#         ("epsilon-0.0", KarmedBanditNonStationary(nb_actions), EGreedyMean(0, nb_actions)),
#         ("epsilon-0.0-optimistic", KarmedBanditNonStationary(nb_actions), EGreedy(0, 0.1, nb_actions, 5)),
#         ("epsilon-0.1-mean", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.1, nb_actions)),
#         ("epsilon-0.1-alpha", KarmedBanditNonStationary(nb_actions), EGreedy(0.1, 0.15, nb_actions)),
#         ("epsilon-0.01-mean", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.01, nb_actions)),
#         ("epsilon-0.01-alpha", KarmedBanditNonStationary(nb_actions), EGreedy(0.01, 0.15, nb_actions)),
#         ("ucb-c_2-alpha_0.1", KarmedBanditNonStationary(nb_actions), UCB(2, 0.1, nb_actions)),
#         ("ucb-mean-c_2", KarmedBanditNonStationary(nb_actions), UCBMean(2, nb_actions)),
#         ("gradientbandit-0.1", KarmedBanditNonStationary(10), GradientBandit(0.01, 10)),
# ]

experiences = [("human", Gridworld((4,4)), MCFirstVisit(0.1, 0.9, 4))]

# experiences = generate_parameters_study("epsilon-", KarmedBandit(10), EGreedy, 0:0.1:0.5)

run_testbed_experiments(nb_runs, nb_steps, experiences)

end # module Uku
