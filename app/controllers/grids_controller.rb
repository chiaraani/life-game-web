# frozen_string_literal: true

# For creating a grid and playing it
class GridsController < ApplicationController
  def new
    @game_id = SecureRandom.uuid
    @grid_data = GridData.new(**Rails.configuration.grid_default)
  end

  def create
    @grid_data = GridData.new(**grid_params)

    if @grid_data.valid?
      PlayJob.perform_later(params['game_id'], @grid_data.transform_values)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def grid_params
    params.require(:grid_data).permit(*GridData.attribute_names)
  end
end
