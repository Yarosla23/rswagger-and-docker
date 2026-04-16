class Api::V1::StudentsController < ApplicationController
  def index
    school = School.find(params[:school_id])
    school_class = school.school_classes.includes(:students).find(params[:class_id])
    students = school_class.students

    render json:  {
      data: Panko::ArraySerializer.new(
        students,
        each_serializer: StudentSerializer
      ).to_a
    }, status: :ok
  end

  def create
    student = Student.new(student_params)

    if student.save
      response.set_header("X-Auth-Token", student.auth_token)

      render json: StudentSerializer.new.serialize_to_json(student), status: :created
    else
      render json: {errors: student.errors.full_messages}, status: :method_not_allowed
    end
  end

  def destroy
    student = Student.find_by(id: params[:user_id])
    return render json: {error: "Некорректный id студента"}, status: :bad_request unless student

    if authorized?(student)
      student.destroy
      head :no_content
    else
      render json: {error: "Некорректная авторизация"}, status: :unauthorized
    end
  end

  private

  def student_params
    source = if params[:student].is_a?(ActionController::Parameters)
      params.require(:student).merge(params.permit(:class_id, :school_class_id))
    else
      params
    end

    permitted = source.permit(:first_name, :last_name, :surname, :school_id, :class_id, :school_class_id)

    permitted[:school_class_id] ||= permitted.delete(:class_id)
    permitted.except(:class_id)
  end

  def authorized?(student)
    token = bearer_token

    student.valid_auth_token?(token)
  end

  def bearer_token
    authorization_header = request.headers["Authorization"].to_s
    scheme, token = authorization_header.split(" ", 2)

    return if scheme != "Bearer"

    token
  end
end
