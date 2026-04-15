class Api::V1::SchoolClassesController < ApplicationController
  def index
    school = School.find(params[:school_id])
    classes = school.school_classes

    render json: {
      data: Panko::ArraySerializer.new(classes, each_serializer: SchoolClassSerializer).to_a
    }, status: :ok
  end
end
