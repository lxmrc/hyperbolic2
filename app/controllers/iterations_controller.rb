class IterationsController < ApplicationController
  before_action :authenticate_user!, only: %i[new run create]
  before_action :set_exercise
  before_action :set_iteration, only: %i[show edit update destroy]

  def show
  end

  def new
    @container = DockerApi.create(exercise: @exercise, user: current_user)
    @container.prepare!
    @iteration = current_user.iterations.build(exercise: @exercise)
  end

  def run
    @container = Container.find_by(token: params[:token])
    render json: @container.run_exercise(params[:code]).to_h.to_json
  end

  def edit
  end

  def create
    @iteration = current_user.iterations.build(iteration_params.merge(exercise: @exercise))

    if @iteration.save
      redirect_to exercise_iteration_path(@exercise, @iteration), notice: "Iteration was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @iteration.update(iteration_params)
      redirect_to @iteration, notice: "Iteration was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @iteration.destroy
    redirect_to iterations_url, notice: "Iteration was successfully destroyed.", status: :see_other
  end

  private

  def set_iteration
    @iteration = Iteration.find(params[:id])
  end

  def set_exercise
    @exercise = Exercise.friendly.find(params[:exercise_id])
  end

  def iteration_params
    params.require(:iteration).permit(:code, :container_id)
  end
end
