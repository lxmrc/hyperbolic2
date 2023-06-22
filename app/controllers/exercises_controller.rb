class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit update destroy ]

  def index
    @exercises = Exercise.all
  end

  def show
    @iterations = @exercise.iterations
  end

  def new
    @exercise = Exercise.new
  end

  def edit
  end

  def create
    @exercise = Exercise.new(exercise_params)

    if @exercise.save
      redirect_to @exercise, notice: "Exercise was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @exercise.update(exercise_params)
      redirect_to @exercise, notice: "Exercise was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy
    redirect_to exercises_url, notice: "Exercise was successfully destroyed.", status: :see_other
  end

  private

  def set_exercise
    @exercise = Exercise.friendly.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :description, :tests)
  end
end
