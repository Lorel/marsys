require 'active_support'
require 'active_support/inflector'

class Marsys::Core
  attr_accessor :environment, :iteration

  def initialize(options={})
    @environment ||= Marsys::Environment.new(@agents, options)  # init environment unless done
    # Marsys::Settings.load!("config.yml")
    # Marsys::Settings.params.merge! options                      
    @iteration = 0
    @iterations = Marsys::Settings.params[:iterations]
  end

  def to_json(options = {})
    @environment.to_json(options.merge(self.add_hash_to_json))
  end
  def add_hash_to_json; {}; end

  def run
    while ( !(self.stop_condition?) ) do
      @environment.turn
      self.display
      @iteration += 1
    end 
  end

  def stop_condition?
    @iterations <= @iteration
  end

  def display_config
    puts "Iterations : #{Marsys::Settings.params[:iterations]}"

    @environment.agents.each do |type|
      puts "#{type.to_s.pluralize.upcase} config :"
      puts "\t- population : #{Marsys::Settings.params["#{type}_population".to_sym] || Marsys::Settings.params[:population]}"
      puts "\t- breeding : #{Marsys::Settings.params["#{type}_breeding".to_sym] || Marsys::Settings.params[:breeding]}"
      puts "\t- starving : #{Marsys::Settings.params["#{type}_starving".to_sym] || Marsys::Settings.params[:starving]}" if Marsys::Settings.params["#{type}_starving".to_sym] || Marsys::Settings.params[:starving]
    end
  end

  def display
    @environment.display
  end

  Symbol.class_eval do
    def pluralize
      to_s.pluralize.to_sym
    end    
  end

  def self.run!
    core = self.new
    core.run
  end
end