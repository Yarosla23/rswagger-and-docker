class Api::V1::SchoolClassesController < Api::V1::BaseController
  def index
    school = School.find(params[:school_id])
    school_classes = school.school_classes

    render_collection(school_classes, serializer: SchoolClassSerializer)
  end
end
