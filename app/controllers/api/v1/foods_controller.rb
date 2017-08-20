class Api::V1::FoodsController < ApplicationController
  def index
    foods = Food.all
    render json: foods
  end

  def show
    food = Food.find_by(id: params[:id])
    if food
      render json: food
    else
      render json: {"Error": "Item not found"}, status: 404
    end
  end

  def create
    food = Food.new(food_params)

    if food.save
      render json: food
    else
      render json: food.errors, status: 400
    end
  end

  def update
    food = Food.find(params[:id])

    if food.update(food_params)
      render json: food
    else
      render json: food.errors, status: 400
    end
  end

  def destroy
    food = Food.find(params[:id])
    if food
      food.destroy
      render json: food
    else
      render json: { "Error": "Can't find specified food to delete" }, status: 404
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :calories)
  end
end
