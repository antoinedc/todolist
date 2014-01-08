module Api
  module V1
    class TasksController < ApplicationController
      respond_to :json

      before_filter :authenticate

      def index
        order = params[:order] || 'desc'
        tasks = @current_user.tasks.order("priority #{order}")
        render :json => tasks
      end

      def show
        begin
          task = Task.where(:user => @current_user, :id => params[:id]).first
          render :json => {:code => 1, :task => task}
        rescue NoMethodError => e
          render :json => {:code => 0, :message => "Can't find this task."}
        end
      end

      def create
        if params[:name] && params[:priority]
          task = Task.new
          task.name = params[:name]
          task.status = false
          task.priority = params[:priority].to_i
          task.user = @current_user
          if task.save
            render :json => task
          else
            render :json => {:code => 0, :message => "Error while saving the task."}
          end
        else
          render :json => {:code => 0, :message => "Wrong parameter."}
        end
      end

      def update
        begin
          task = Task.where(:user => @current_user, :id => params[:id]).first
          task.name = params[:name] if params[:name]
          task.priority = params[:priority].to_i if params[:priority]
          task.status = params[:status] if params.has_key?(:status)
          if task.save
            render :json => {:code => 1, :task => task}
          else
            render :json => {:code => 0, :message => "Error while updating the task."}
          end
        rescue NoMethodError => e
          render :json => {:code => 0, :message => "Can't find this task."}
        end
      end

      def destroy
        begin
          task = Task.where(:user => @current_user, :id => params[:id]).first
          if task.destroy
            render :json => {:code => 1}
          else
            render :json => {:code => 0, :message => "Error while destroying the task"}
          end
        rescue NoMethodError => e
          render :json => {:code => 0, :message => "Can't find this task."}
        end        
      end
    end
  end
end