class ContainersController < ApplicationController
  before_action :set_container, only: %i[show edit update destroy]

  def index
    @containers = Container.all
  end

  def show
  end

  def new
    @container = Container.new
  end

  def edit
  end

  def create
    @container = Container.new(container_params)

    if @container.save
      redirect_to @container, notice: "Container was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @container.update(container_params)
      redirect_to @container, notice: "Container was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @container.destroy
    redirect_to containers_url, notice: "Container was successfully destroyed.", status: :see_other
  end

  private

  def set_container
    @container = Container.find(params[:id])
  end

  def container_params
    params.require(:container).permit(:docker_id, :name, :image)
  end
end
