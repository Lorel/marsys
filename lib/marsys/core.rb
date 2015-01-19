require 'active_support'
require 'active_support/inflector'

class Marsys::Core
  attr_accessor :environment

  def initialize(options={})
    Marsys::Settings.load!("config.yml")
    Marsys::Settings.params.merge! options              # override default settings
    @iterations = Marsys::Settings.params[:iterations]
    @environment ||= Marsys::Environment.new(@agents)   # init environment if necessary
  end

  def run
    @iterations.times {
      @environment.turn
      @environment.display
    }
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
end