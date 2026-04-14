module Api
  module V1
    class SchoolClassesController < ApplicationController
      before_action :set_school

      def index
        render json: @school.school_classes
      end

      def create
        school_class = @school.school_classes.new(school_class_params)
        if school_class.save
          render json: school_class, status: :created
        else
          render json: { errors: school_class.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_school
        @school = School.find(params[:school_id])
      end

      def school_class_params
        params.require(:school_class).permit(:number, :letter, :students_count)
      end
    end
  end
end
