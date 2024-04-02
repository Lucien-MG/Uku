struct Blackjack
    cards::Array{Int8}
    table::Matrix{Int8}

    function Blackjack()
        # Cards points
        card_numbers = [2, 3, 4, 5, 6, 7, 8, 9]
        card_faces = [10, 10, 10]
        card_aces = [11]

        cards = [card_numbers; card_faces; card_aces]

        # Player sum, dealer visble card
        table = zeros(Int8, 1, 3)
        table[1, 1] = rand(cards) + rand(cards)
        table[1, 2] = rand(cards)

        if table[1, 1] == 22
            table[1, 1] -= 10
        end

        return new(cards, table)
    end
end

function step(blackjack::Blackjack, action::Vector{Float64})
    if action[1] == 1
        blackjack.table[1, 1] += rand(blackjack.cards)

        if blackjack.table[1, 1] > 21
            return blackjack.table, -1., true
        end

        if blackjack.table[1, 1] == 21
            return blackjack.table, 1.5, true
        end
    end

    if action[2] == 1
        blackjack.table[1, 2] += rand(blackjack.cards)

        if blackjack.table[1, 2] > 21
            return blackjack.table, 1., true
        end

        if blackjack.table[1, 2] == 21
            return blackjack.table, -1., true
        end

        if blackjack.table[1, 1] > blackjack.table[1, 2]
            return blackjack.table, 1., true
        else
            return blackjack.table, -1., true
        end

        return blackjack.table, 0., true
    end

    return blackjack.table, 0., false
end

function reset(blackjack::Blackjack)
    blackjack.table[1, 1] = rand(blackjack.cards) + rand(blackjack.cards)
    blackjack.table[1, 2] = rand(blackjack.cards)
    blackjack.table[1, 3] = 0

    if table[1, 1] == 22
        table[1, 1] -= 10
    end
    
    return blackjack.table
end
