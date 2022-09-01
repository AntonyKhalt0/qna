require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    before do
     login(user)
     question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    it 'deletes the attachment file' do
      expect { delete :destroy, params: { id: question.files.last.id }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params: { id: question.files.last.id }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
