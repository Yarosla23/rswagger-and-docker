module Api
  module V1
    class SchoolsController < ApplicationController
      def index
        render json: School.all
      end

      def show
        render json: School.find(params[:id])
      end

      def create
        school = School.new(school_params)
        if school.save
          render json: school, status: :created
        else
          render json: { errors: school.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def school_params
        params.require(:school).permit(:name)
      end
    end
  end
end
