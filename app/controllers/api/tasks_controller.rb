class Api::TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    tasks = Task.all
    render json: tasks
  end
  def show
    task = Task.find params[:id]
    render json: task
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Tarea no encotrada" }, status: :not_found
  end
  def create
    task = Task.new task_params
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    task = Task.find params[:id]
    if task.update task_params
      render json: task
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  rescue
    render json: { error: { error: "Tarea no encontrada" }, status: :not_found }
  end
  def destroy
    task = Task.find(params[:id])
    task.destroy
    render json: { message: "Tarea eliminada correctamente" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Tarea no encontrada" }, status: :not_found
  end
  private
  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date)
  end
end
