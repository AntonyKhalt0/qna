require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :image_url }
end
