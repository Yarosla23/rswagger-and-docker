class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_errors(errors, status: :unprocessable_entity)
    render json: { errors: Array(errors) }, status:
  end

  def render_error(message, status:)
    render json: { error: message }, status:
  end

  def render_not_found(exception)
    model_name = exception.model.to_s.underscore.humanize

    render_error("#{model_name} не найден", status: :not_found)
  end
end
