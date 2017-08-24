class Api::V1::MealsController < ApplicationController
  before_filter :find_food, except: [:index, :show]
  before_filter :find_meal, except: [:index]

  def index
    @meals = Meal.all

    render json: @meals, status: 200
  end

  def show
    if @meal
      render json: @meal, status: 200
    else
      render json: { message: "Can't find meal with id of #{params[:meal_id]}"}, status: 404
    end
  end

  def create
    if food_and_meal_exist?
      @meal.foods << @food

      render json: { message: "Successfully added #{@food.name} to #{@meal.name}"}, status: 201
    else
      render json: { message: "Cannot find requested meal and/or food to add food to specified meal" }, status: 404
    end
  end

  def destroy
    if food_and_meal_exist?
      meal_food = MealFood.find_by(meal: @meal, food: @food)
      meal_food.destroy

      render json: { message: "Successfully removed #{@food.name} from #{@meal.name}", food: @food.id, meal: @meal.id}, status: 200
    else
      render json: { message: "Cannot find requested meal and/or food to delete" }, status: 404
    end
  end

  private

  def food_and_meal_exist?
    @meal && @food
  end

  def find_meal
    @meal ||= Meal.find_by(id: params[:meal_id])
  end

  def find_food
    @food ||= Food.find_by(id: params[:id])
  end
end
