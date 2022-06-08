class Api::PipelinesController < Api::ApplicationController
  def index
    pipelines = current_user.pipelines

    render status: :ok,
            json: pipelines
  end

  def create
    pipeline = current_user.pipelines.build(pipeline_params)

    pipeline.save!

    render status: :created,
            json: pipeline
  end

  private

  def pipeline_params
    params.require(:pipeline).permit(:name)
  end
end
