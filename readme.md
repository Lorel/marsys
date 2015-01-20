# MARSYS : Multi-Agents Ruby System

MARSYS is a study project aimed to be used as a core for a multi-agents system such as [Wator](http://cs.nyu.edu/~hain/wator/) or the [Schelling Segregation Model](http://web.mit.edu/rajsingh/www/lab/alife/schelling.html)

This gem provides a core to stand simple agents-based models and run simulations

# HOW TO START ?

Add gem to your Gemfile

```ruby
gem "marsys", '0.0.0', git: 'https://github.com/Lorel/marsys.git', branch: 'v0.0.0'
```

Or build and install it

```bash
$ git clone https://github.com/Lorel/marsys.git
$ cd marsys
$ gem build marsys.gemspec
$ gem install marsys-0.0.0.gem
```

Then require it, and extend Marsys classes

```ruby
require 'marsys'

class Core < Marsys::Core
  def initialize(options={})
    @agents = [:blue, :green]                       # set the different types of agents
    @environment = Environment.new(@agents,options) # instanciate your environment
    super(options)
  end
end

class Environment < Marsys::Environment
  # puts methods which acts on your environment here
end

class Agent < Marsys::Agent
                                                 # set here stuffs to do before or 
  def turn                                       # after the parent class
    puts "Hey ! I'm a #{self.class.to_s} agent"
    super
    puts "I'm always a #{self.class.to_s} agent, yeah !"
  end
end

class Blue < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :blue                                # set color of your agent
  end
end

class Green < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :green
  end
end

core = Core.new
core.display
core.run

```


# EXAMPLES

- implementation of Wator : https://github.com/Lorel/wator_rb
- implementation of Schelling Segregation Model : https://github.com/Lorel/segregation_rb
