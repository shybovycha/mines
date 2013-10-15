class Mines
    attr_accessor :field
    attr_accessor :dimension

    def initialize
        build_field(rand(10) + 1, rand(10))
    end

    def build_field(dimension, number_of_mines)
        @field = []
        @dimension = dimension

        free_cells = (0..(dimension - 1)).to_a
        free_cells = free_cells.combination(free_cells)

        dimension.times { field << [ -1 ] * dimension }

        number_of_mines.times do
            sample_index = rand(free_cells.size)
            x, y = free_cells[sample_index]
            free_cells.delete_at sample_index
            @field[x][y] = 1
        end

        @field
    end

    def win_game

    end

    def lose_game

    end

    def show_number(x,y, number = nil)
        number = get_neighbours(x, y) if number.nil?
    end

    def all_cells_guessed?
        @field.all? { |cell| cell > -1 }
    end

    def get_free_neighbours(x, y)
        neighbours = [
            [x - 1, y - 1],
            [x - 1, y],
            [x - 1, y + 1],
            [x, y - 1],
            [x, y + 1],
            [x + 1, y - 1],
            [x + 1, y],
            [x + 1, y + 1]
        ]

        neighbours.reject { |pair| pair[0] < 0 or pair[0] > @dimension - 1 or pair[1] < 0 or pair[1] > @dimension - 1 }
    end

    def get_neighbours(x, y)
        cnt = 0

        neighbours = get_free_neighbours(x, y)

        neighbours.each do |pair|
            i, t = pair[0], pair[1]

            if @field[i][t] > 0
                cnt += 1
            end
        end

        cnt
    end

    def open_all_neighbours_around(x, y)
        show_number(x, y)

        if get_neighbours(x, y) > 0 or @field[x][y] > 0
            return
        end

        neighbours = get_free_neighbours(x, y)

        neighbours.each { |pair| open_all_neighbours_around(pair[0], pair[1]) }
    end

    def open(x, y)
        return win_game if all_cells_guessed?

        neighbour_cnt = get_neighbours(x, y)

        if @field[x][y] == 0
            if neighbour_cnt > 0
                show_number(x, y, neighbour_cnt)
            else
                open_all_neighbours_around(x, y)
            end
        else
            lose_game
        end
    end
end