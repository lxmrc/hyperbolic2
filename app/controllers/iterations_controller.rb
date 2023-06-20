class IterationsController < ApplicationController
  before_action :set_iteration, only: %i[ show edit update destroy ]

  # GET /iterations
  def index
    @iterations = Iteration.all
  end

  # GET /iterations/1
  def show
  end

  # GET /iterations/new
  def new
    @iteration = Iteration.new
  end

  # GET /iterations/1/edit
  def edit
  end

  # POST /iterations
  def create
    @iteration = Iteration.new(iteration_params)

    if @iteration.save
      redirect_to @iteration, notice: "Iteration was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /iterations/1
  def update
    if @iteration.update(iteration_params)
      redirect_to @iteration, notice: "Iteration was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /iterations/1
  def destroy
    @iteration.destroy
    redirect_to iterations_url, notice: "Iteration was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iteration
      @iteration = Iteration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def iteration_params
      params.require(:iteration).permit(:code, :exercise_id, :user_id)
    end
end
