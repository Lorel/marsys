require 'colorize'

class Marsys::Agent
  attr_accessor :square, :age

  def initialize(environment, square = nil)
    @breeding_time = Marsys::Settings.params[:breeding]
    @breeding = 0
    @environment= environment
    @square = square
    @square.content = self if square # set square content with new fish if square provided
    @age = 0
    @color = :white
  end

  def to_json(options = {})
    {
      type: self.class.to_s.downcase,
      age:  @age
    }.to_json
  end

  def move
    @old_square = @square
    @square = @environment.empty_squares_around(@square).sample || @old_square
    @old_square = nil if @old_square == @square # no old_square if fish does not move
    @old_square.content = nil if @old_square # reset old_square content if @old_square exists (fish has moved)
    @square.content = self if @old_square # update square content if @old_square exists (fish has moved)
  end

  def turn
    move
    @age += 1
  end

  def die
    @square.content = nil
    collection.delete(self)
  end

  def collection
    @environment.send((self.class.to_s.downcase + "s").to_sym)
  end

  def char
    self.class.to_s[0].send(@color)
  end
end