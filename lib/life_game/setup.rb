# frozen_string_literal: true

require_relative 'grid'

# Setup asks client for config variables
class Setup
  def self.gets
    $stdin.gets
  end

  def self.ask(variable, question)
    Rails.logger.debug { "#{question} (#{Grid.config[:default][variable]})" }
    answer = gets

    @config[variable] = answer.to_f unless answer.strip.empty?
  end

  def self.ask_for_config
    @config = {}

    ask :rows, 'How many rows?'
    ask :columns, 'How many columns?'
    ask :phase_duration, 'How long is each phase (in seconds)?'
    ask :phases, 'How many phases?'

    Grid.new(**@config).play
  end
end
