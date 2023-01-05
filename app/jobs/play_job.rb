# frozen_string_literal: true

# It plays life game
class PlayJob < ApplicationJob
  queue_as :default

  def perform(game_id, grid_attributes)
    @grid = GridData.new(grid_attributes).to_grid
    
    @grid.play { broadcast_to(game_id) } 
  end

  def broadcast_to(game_id)
    Turbo::StreamsChannel.broadcast_update_to(
      [:play, game_id],
      target: 'grid',
      partial: 'grids/grid',
      locals: { grid: @grid }
    )
  end
end
