# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:awards) { create_list(:awards, 2, user_id: user.id) }

    before do
      login(user)
      get :index
    end

    it 'get all awards' do
      expect(assigns(:awards)).to match_array(awards)
    end

    it 'render index template' do
      expect(response).to render_template :index
    end
  end
end
