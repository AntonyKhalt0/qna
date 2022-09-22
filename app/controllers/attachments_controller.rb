class AttachmentsController < ApplicationController
  before_action :attachment, only: :destroy
  
  authorize_resource
  
  def destroy
    @attachment.purge
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
