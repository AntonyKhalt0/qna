# frozen_string_literal: true

shared_examples_for 'Votable' do
  it { should have_many :votes }
end
