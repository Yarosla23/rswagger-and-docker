class Api::V1::StudentsController < Api::V1::BaseController
  include BearerTokenAuthenticatable

  def index
    school = School.find(params[:school_id])
    school_class = school.school_classes.find(params[:class_id])

    render_collection(school_class.students, serializer: StudentSerializer)
  end

  def create
    student = Student.new(student_params)

    if student.save
      response.set_header("X-Auth-Token", student.auth_token)
      render_resource(student, serializer: StudentSerializer, status: :created)
    else
      render_errors(student.errors.full_messages, status: :method_not_allowed)
    end
  end

  def destroy
    student = Student.find_by(id: params[:user_id])
    return render_error("Некорректный id студента", status: :bad_request) if student.blank?

    return render_error("Некорректная авторизация", status: :unauthorized) unless student.valid_auth_token?(bearer_token)

    student.destroy
    head :no_content
  end

  private

  def student_params
    permitted_attributes = params.permit(
      :first_name,
      :last_name,
      :surname,
      :school_id,
      :class_id,
      :school_class_id
    )

    permitted_attributes[:school_class_id] = permitted_attributes.delete(:class_id)
    permitted_attributes.except(:class_id)
  end
end
