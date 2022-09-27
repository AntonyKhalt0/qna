# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: 'User'

      def index
        render json: all_users_without_current
      end

      def me
        render json: current_resource_owner
      end

      private

      def all_users_without_current
        @users = User.where.not(id: current_resource_owner.id)
      end
    end
  end
end
