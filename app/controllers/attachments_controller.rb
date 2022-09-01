class AttachmentsController < ApplicationController
  before_action :attachment, only: :destroy

  def destroy
    @attachment.purge
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
