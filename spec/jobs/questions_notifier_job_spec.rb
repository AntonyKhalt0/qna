require 'rails_helper'

RSpec.describe QuestionsNotifierJob, type: :job do
  let(:service) { double('QuestionsNotifier') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  before do
    allow(QuestionsNotifier).to receive(:new).and_return(service)
  end

  it 'calls QuestionsNotifier#send_digest' do
    expect(service).to receive(:send_digest).with(answer)
    DailyDigestJob.perform_now
  end
end
