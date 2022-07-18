# frozen_string_literal: true

class PlayJob < ApplicationJob
  queue_as :default

  def perform(**args)
    Grid.new(**args).play
  end
end
