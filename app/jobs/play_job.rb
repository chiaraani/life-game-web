# frozen_string_literal: true

# It plays life game
class PlayJob < ApplicationJob
  queue_as :default

  def perform(game_id, grid_attributes)
    @grid = Grid.new grid_attributes

    @grid.play { broadcast_to(game_id) }
  end

  private

  def broadcast_to(game_id)
    Turbo::StreamsChannel.broadcast_update_to(
      [:play, game_id],
      target: 'grid',
      partial: 'grids/grid',
      locals: { grid: @grid }
    )
  end
end
