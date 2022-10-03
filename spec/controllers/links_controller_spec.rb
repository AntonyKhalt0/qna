# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:link) { create(:link, linkable: question) }

    before do
      login(user)
    end

    it 'deletes the attachment link' do
      expect { delete :destroy, params: { id: question.links.last.id }, format: :js }.to change(Link, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params: { id: question.links.last.id }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
