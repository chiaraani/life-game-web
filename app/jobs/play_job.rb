# frozen_string_literal: true

# It plays life game
class PlayJob < ApplicationJob
  queue_as :default

  def perform(**grid_attributes)
    GridData.new(grid_attributes).to_grid.play
  end
end
