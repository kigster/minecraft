module MineCraft
  class Field
    attr_accessor :rows, :string, :big

    def initialize(string)
      parse(string)
      self.big = biggest
    end

    def width
      rows.first.size
    end

    def height
      rows.size
    end

    def value_at(x:, y:)
      if x < 0 || x >= width || y < 0 || y >= height
        nil
      else
        rows[y][x]
      end
    end

    def to_s
      out = ''
      rows.each_with_index do |row, y|
        row.map { |v| v == -1 ? '▇' : (v == 0 ? '.' : v.to_s) }.each_with_index do |v, x|
          out << (x == big.x && y == big.y ? 'X' : v)
        end
        out << "\n"
      end
      out
    end

    def value(x, y)
      value_at(x: x, y: y)
    end

    def set_value_at(x:, y:, value:)
      rows[y][x] = value
    end

    def value!(x, y, value)
      set_value_at(x: x, y: y, value: value)
    end

    def total
      rows.flatten.map(&:abs).sum
    end

    def damage
      rows.flatten.select { |v| v < 0 }.sum.abs
    end

    def mine?(x, y)
      value(x, y) == 1
    end

    def explode(x, y)
      return 0 if value(x, y) != 1
      mines_found = 1
      value!(x, y, -1)
      [-1, 0, 1].each { |i|
        [-1, 0, 1].each { |j|
          next if i == 0 && j == 0
          x1 = x + i
          y1 = y + j
          if x1 >= 0 && x1 < width && y1 >= 0 && y1 < height
            if mine?(x1, y1)
              mines_found += explode(x1, y1)
            else
              value!(x1, y1, -1)
            end
          end
        }
      }
      mines_found
    end

    MineMax = Struct.new(:x, :y, :mines)

    def biggest
      x1, y1 = -1, -1
      max = -1
      rows.each_with_index do |row, y|
        row.each_with_index do |value, x|
          if value == 1
            mines = self.explode(x, y)
            if mines > max
              max = mines
              x1  = x
              y1  = y
            end
            revert!
          end
        end
      end

      MineMax.new(x1, y1, max)
    end

    private

    def parse(string)
      self.string = string
      self.rows   = []
      string.split("\n").each do |line|
        self.rows << line.gsub(/\./, '0').scan(/\w/).map(&:to_i)
      end
    end

    def revert!
      parse(string)
    end
  end
end

