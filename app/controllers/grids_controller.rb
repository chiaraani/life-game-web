# frozen_string_literal: true

# For creating a grid and playing it
class GridsController < ApplicationController
  def new
    @grid_data = GridData.default
  end

  def create
    @grid_data = GridData.new(**grid_params)

    if @grid_data.valid?
      play
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def grid_params
    params.require(:grid_data).permit(*GridData.attribute_names)
  end

  def play
    @job_id = PlayJob.perform_later(**@grid_data.attributes).job_id
    render :play, status: :created
  end
end
