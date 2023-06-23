class IterationsController < ApplicationController
  before_action :authenticate_user!, only: %[new run create]
  before_action :set_exercise
  before_action :set_iteration, only: %i[show edit update destroy]
  before_action :set_container, only: :run
  before_action :prepare_container, only: :new

  def show
  end

  def new
    @iteration = current_user.iterations.build(exercise: @exercise)
  end

  def run
    @container.store_file("/hyperbolic/exercise.rb", params[:code])
    render json: @container.run_tests
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

  def set_container
    @container = Container.find_by(docker_id: params[:container_id])
  end

  def prepare_container
    @container = DockerApi.create(exercise: @exercise, user: current_user)
    @container.store_file("/hyperbolic/test.rb", @exercise.tests)
    @container.start
  end

  def iteration_params
    params.require(:iteration).permit(:code, :container_id)
  end
end
