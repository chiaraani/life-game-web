# frozen_string_literal: true

# For creating a grid and playing it
class GridsController < ApplicationController
  def new
    @grid_data = GridData.default
  end

  def create
    @grid_data = GridData.new(**grid_params)

    if @grid_data.valid?
      PlayJob.perform_later(**@grid_data.attributes)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def grid_params
    params.require(:grid_data).permit(*GridData.attribute_names)
  end
end
