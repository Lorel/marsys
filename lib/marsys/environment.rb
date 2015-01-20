require 'pp'
require 'json'

class Marsys::Environment
  attr_accessor :grid, :agents_type

  def initialize(agents=[], options={})
    Marsys::Settings.load!("config.yml")    # load default settings
    Marsys::Settings.params.merge! options  # override default settings

    @agents_type = agents

    # create accessors for each type of agents
    @agents_type.each do |type|
      self.class.send(:attr_accessor, type.pluralize)

      # init agent collection with empty Array
      self.send("#{type.pluralize}=", [])
    end

    pp Marsys::Settings.params

    # init config
    @size       = Marsys::Settings.params[:dimensions] # dimensions of the grid
    @population = Marsys::Settings.params[:population] # population by default

    # init common attributes
    @iteration = 0
    @grid = Array.new(@size) { Array.new(@size) }
    @size.times do |x|
      @size.times do |y|
        @grid[x][y] = Square.new(x,y)
      end
    end

    # init agents on grid
    squares = @grid.clone.flatten

    @agents_type.each do |type|
      (Marsys::Settings.params["#{type}_population".to_sym] || @population).times {
        agent = type.to_s.capitalize.constantize.new(self)    # create new agent
        self.send(type.pluralize).send(:push, agent)          # store agent in its collection
        square = squares.delete(squares.sample)               # pick up a random square in squares
        square.content = agent                                # set square content with the agent
        agent.square = square                                 # set agent square with 
      }
    end

    # init methods specific to agents
    create_agents_specific_methods
  end

  def agents
    # init @agents instance variable
    @agents_type.map{|type| self.send(type.pluralize)}.flatten
  end

  def to_json(options = {})
    {
      grid:       @grid.map{|line| line.map{ |square|
                    square.content ? square.content.class.to_s.downcase : nil
                  }},
      iteration:  @iteration
    }.to_json
  end

  def turn
    @iteration += 1
    agents.shuffle.each{ |agent| agent.turn }
  end

  def display
    display_grid
    display_stats
  end

  def display_grid
    puts "__" * @size + "\n" + @grid.inject(""){ |res,line| res + line.inject(""){ |res,square| res + square.char + " " } + "\n" } + "__" * @size + "\n"
  end

  def display_stats
    puts "Agents population : #{@grid.flatten.reject{|s| s.content.nil?}.count}"
  end

  def empty_squares
    @grid.flatten.select{ |s| s.content.nil? }
  end

  def squares_around square
    squares = []
    (([0,square.x-1].max)..([@size-1,square.x+1].min)).each do |x|
      (([0,square.y-1].max)..([@size-1,square.y+1].min)).each do |y|
        squares << @grid[x][y] unless x == square.x && y == square.y
      end
    end
    squares
  end

  def empty_squares_around square
    squares_around(square).select{ |s| s.content.nil? }
  end

  private

    def create_agents_specific_methods
      squares_around_with_initialize
    end

    def self.initialize_methods(*names)
      names.each do |name|
        self.send(name)
      end
    end

    def squares_around_with_initialize
      @agents_type.each do |type|
        self.class.send( :define_method, "squares_around_with_#{type}", Proc.new{ |argument|
          squares_around(argument).select{ |s| s.content.is_a? type.to_s.capitalize.constantize }
        })
      end
    end

  class Square
    attr_accessor :x,:y,:content

    def initialize(x,y)
      @size = Marsys::Settings.params[:dimensions]
      raise SquareOutOfRangeException.new unless ((0..(@size-1)).include?(x) || (0..(@size-1)).include?(y))
      @x, @y = x, y
    end

    def to_json(options = {})
      {
        content:  @content,
        x:        @x,
        y:        @y
      }.to_json
    end

    def char
      @content ? @content.char : "-"
    end
  end

  class SquareOutOfRangeException < Exception ; end
end
