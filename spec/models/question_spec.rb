require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }
  it { should have_one :award }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :rating }
  
  it_behaves_like 'Attachmentable'
  it_behaves_like 'Linkable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Votable'
  it_behaves_like 'Author'
end
