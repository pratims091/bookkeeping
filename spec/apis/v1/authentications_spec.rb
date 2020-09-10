# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthenticationsController, type: :controller do
  let(:response_json) { JSON.parse(response.body) }
  let(:response_status) { response.status }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  feature 'Existing user login with a valid OTP' do
    before do
      post :login, format: :json, params: { otp: 1234, phone_number: user1.phone_number }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('user')
      expect(response_json.keys).to include('token')
      expect(response_json['user']['id']).to eq user1.id
    end
  end

  feature 'Existing user login with an invalid OTP' do
    before do
      post :login, format: :json, params: { otp: 1, phone_number: user1.phone_number }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 401
      expect(response_status).not_to eq 200
      expect(response_json['error']['code']).to eq 1002
    end
  end

  feature 'Non-Existing user login with a valid OTP' do
    before do
      post :login, format: :json, params: { otp: 1234, phone_number: '123456789' }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 401
      expect(response_status).not_to eq 200
      expect(response_json['error']['code']).to eq 1001
    end
  end

  feature 'Non-Existing user login with an invalid OTP' do
    before do
      post :login, format: :json, params: { otp: 1, phone_number: '123456789' }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 401
      expect(response_status).not_to eq 200
      expect(response_json['error']['code']).to eq 1002
    end
  end
end
