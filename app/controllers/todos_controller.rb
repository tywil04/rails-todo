class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /todos or /todos.json
  def index
    @todos = Todo.where(user: current_user)
  end

  # GET /todos/1/edit
  def edit
    if @todo.user != current_user
      respond_to do |format|
        format.html { redirect_to todos_path }
      end
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.turbo_stream
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    if @todo.user == current_user
      respond_to do |format|
        if @todo.update(todo_params)
          format.turbo_stream
        end
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    if @todo.user == current_user
      @todo.destroy

      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.fetch(:todo, {}).permit(:title, :completed).merge("user" => current_user)
    end
end
