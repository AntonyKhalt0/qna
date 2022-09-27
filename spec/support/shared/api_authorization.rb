# frozen_string_literal: true

shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'return 401 status if there is no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'return 401 status if access token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API success response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'API error response' do
  it 'return errors' do
    do_request(method, api_path,
               params: { access_token: access_token.token, resource => attributes_for(resource, trait) }, headers: headers)
    expect(response.status).to eq 422
  end
end
