# frozen_string_literal: true

shared_examples_for 'Author' do
  it { should belong_to :author }
end
