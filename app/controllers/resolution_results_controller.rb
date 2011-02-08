class ResolutionResultsController < ApplicationController
  
  before_filter :authenticate
  before_filter :user_is_resolution_owner
  
  def update
    @resolution_result = ResolutionResult.find(params[:id])
    @resolution_result.times_completed = params[:resolution_result][:times_completed]
    @resolution_result.save
    redirect_to(@resolution_result.resolution)
  end

  private
    
    def user_is_resolution_owner
      resolution_result = ResolutionResult.find(params[:id])
      redirect_to(root_path) unless current_user?(resolution_result.resolution.user)
    end
end
