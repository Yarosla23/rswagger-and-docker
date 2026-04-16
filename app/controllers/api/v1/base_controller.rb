class Api::V1::BaseController < ApplicationController
  private

  def render_collection(collection, serializer:)
    render json: {
      data: Panko::ArraySerializer.new(collection, each_serializer: serializer).to_a
    }, status: :ok
  end

  def render_resource(resource, serializer:, status:)
    render json: JSON.parse(serializer.new.serialize_to_json(resource)), status:
  end
end
