require 'colorize'

class Marsys::Agent

  attr_accessor :square

  def initialize(environment, square = nil)
    @environment= environment
    @square = square
    @square.content = self if square # set square content with new agent if square provided
    
    @color = :white
  end

  def to_json(options = {})
    {
      type: self.class.to_s.downcase
    }.to_json
  end

  def move ; end

  def move_close
    @old_square = @square
    @square = @environment.empty_squares_around(@square).sample || @old_square
    @old_square = nil if @old_square == @square # no old_square if agent does not move
    @old_square.content = nil if @old_square # reset old_square content if @old_square exists (agent has moved)
    @square.content = self if @old_square # update square content if @old_square exists (agent has moved)
  end

  def move_far
    @old_square = @square
    @square = @environment.empty_squares.sample || @old_square
    @old_square = nil if @old_square == @square # no old_square if agent does not move
    @old_square.content = nil if @old_square # reset old_square content if @old_square exists (agent has moved)
    @square.content = self if @old_square # update square content if @old_square exists (agent has moved)
  end

  def turn
    move
  end

  def collection
    @environment.send((self.class.to_s.downcase + "s").to_sym)
  end

  def char
    self.class.to_s[0].send(@color)
  end
end