# app/controllers/api/v1/students_controller.rb
module Api
  module V1
    class StudentsController < ApplicationController
      def index
        students = Student.all
        render json: Panko::ArraySerializer.new(students, each_serializer: StudentSerializer).to_json
      end

      def show
        student = Student.find(params[:id])
        render json: StudentSerializer.new.serialize_to_json(student)
      end

      def create
        student = Student.new(student_params)
        if student.save
          render json: StudentSerializer.new.serialize_to_json(student), status: :created
        else
          render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def student_params
        params.require(:student).permit(:first_name, :last_name, :surname, :school_id, :school_class_id)
      end
    end
  end
end
