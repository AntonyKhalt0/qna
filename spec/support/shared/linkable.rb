shared_examples_for 'Linkable' do
  it { should have_many :links }
  it { should accept_nested_attributes_for :links }
end
