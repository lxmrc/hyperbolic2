class ContainersController < ApplicationController
  before_action :set_container, only: %i[start stop show edit update destroy]

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
    @container = DockerApi.create(user: current_user)

    if @container
      redirect_to containers_path, notice: "Container was successfully created."
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

  def start
    @container.start
    redirect_to containers_path
  end

  def stop
    @container.stop
    redirect_to containers_path
  end

  private

  def set_container
    @container = Container.find(params[:id])
  end

  def container_params
    params.require(:container).permit(:docker_id, :name, :image)
  end
end
