require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :rating }
  
  it { should have_db_index :question_id }

  it_behaves_like 'Attachmentable'
  it_behaves_like 'Linkable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Votable'
  it_behaves_like 'Author'
end
