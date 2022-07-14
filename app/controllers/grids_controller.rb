# frozen_string_literal: true

# For creating a grid and playing it
class GridsController < ApplicationController
  def new
    @grid = Grid.new
    @grid.set_default!
  end

  def create
    @grid = Grid.new(**grid_params)

    if @grid.valid?
      play
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def grid_params
    params.require(:grid).permit(*Grid.attribute_names)
  end

  def play
    render :play, status: :created
  end
end
