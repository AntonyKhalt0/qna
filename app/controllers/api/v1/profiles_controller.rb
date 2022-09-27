class Api::V1::ProfilesController < Api::V1::BaseController
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
