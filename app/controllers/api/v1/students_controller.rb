class Api::V1::StudentsController < ApplicationController
  def index
    school = School.find(params[:school_id])
    school_class = school.school_classes.includes(:students).find(params[:class_id])
    students = school_class.students
    render json:  {
      data: Panko::ArraySerializer.new(
        students,
        each_serializer:  StudentSerializer
      ).to_a
    }, status: :ok
  end

  def create
    student = Student.new(student_params)

    if student.save

      student.school_class.update(students_count:)
      response.set_header("X-Auth-Token", student.generate_token)

      render json:  StudentSerializer.new.serialize_to_json(student), status: :created
    else
      render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    student = Student.find_by(id: params[:id])
    return render json: { error: "Некорректный id студента" }, status: :bad_request unless student

    if authorized?(student)
      student.destroy
      head :no_content
    else
      render json: { error: "Некорректная авторизация" }, status: :unauthorized
    end
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :surname, :school_id, :class_id)
  end

  def authorized?(student)
    token = request.headers["Authorization"]&.split(" ")&.last
    token.present? && token == student.generate_token
  end
end
