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

include("reinforcement-learning/sarsa/Sarsa.jl")
include("reinforcement-learning/sarsa/Qlearning.jl")

include("reinforcement-learning/human/HumanAgent.jl")

function play_env(env, agent)
    reset(agent)

    finished = false
    index_step = 1

    state = reset(env)
    previous_state = copy(state)

    while !finished
        action = policy(agent, state)

        state, reward, finished = step(env, action)

        learn(agent, previous_state, state, action, reward)

        previous_state .= state
        index_step += 1
    end

    return index_step
end

function run_episodes(name, env, agent, nb_runs)
    nb_steps_by_episode = zeros(nb_runs)
    optimal_moves = zeros(nb_runs)

    for i=1:nb_runs
        steps_played = play_env(env, agent)

        nb_steps_by_episode[i] = steps_played
    end

    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return name, nb_steps_by_episode, optimal_moves
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

function run_experiments(nb_runs, experiences)
    results_exps = []

    Threads.@threads for exp in experiences
        # Experience title
        println(Threads.threadid(), ": ", exp[1], " - running")
    
        # Run experiences
        @time results = run_episodes(exp[1], exp[2], exp[3], nb_runs)

        # Store experiences's results
        push!(results_exps, results)
    end

    return results_exps
end

# function generate_parameters_study(name, env, agent, parameters)
#     experiences = []

#     for i in 1:length(parameters)
#         exp = (name * string(parameters[i]), KarmedBandit(10), agent(parameters[i], 0.1, 10, 4))
#         # push!(experiences, exp)
#     end

#     return experiences
# end

nb_actions = 10
nb_runs = 100

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

experiences = [
    ("Qlearning", Gridworld((4,4)), Sarsa(0.1, 0.5, 0.9, 4)),
    # ("Human", Gridworld((4,4)), HumanAgent()),
]

# experiences = generate_parameters_study("epsilon-", KarmedBandit(10), EGreedy, 0:0.1:0.5)

results_exps = run_experiments(nb_runs, experiences)

save_experiences(results_exps)

end # module Uku
