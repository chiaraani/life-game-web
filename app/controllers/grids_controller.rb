# frozen_string_literal: true

# For creating a grid and playing it
class GridsController < ApplicationController
  def new; end

  def create
    @grid = Grid.new(**grid_params)

    if @grid.valid?
      redirect_to :play, params: grid_params
    else
      render :new
    end
  end

  private

  def grid_params
    params.require(:grid).permit(*Grid.config[:attribute_keys])
  end
end
