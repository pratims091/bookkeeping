# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:response_json) { JSON.parse(response.body) }
  let(:response_status) { response.status }
  let(:user1) { create(:user) }

  feature 'Create a new user with a valid OTP and unregisterd phone number' do
    before do
      post :create, format: :json, params: {
        otp: 1234,
        user: {
          phone_number: Faker::PhoneNumber.cell_phone_in_e164,
          name: Faker::Name.name
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('user')
      expect(response_json.keys).to include('token')
    end
  end

  feature 'Create a new user with a valid OTP, unregisterd phone number and without name' do
    before do
      post :create, format: :json, params: {
        otp: 1234,
        user: {
          phone_number: Faker::PhoneNumber.cell_phone_in_e164
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('user')
      expect(response_json.keys).to include('token')
    end
  end

  feature 'Create a new user with a valid OTP and registerd phone number' do
    before do
      post :create, format: :json, params: {
        otp: 1234,
        user: {
          phone_number: user1.phone_number
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).not_to eq 201
      expect(response_status).to eq 422
      expect(response_json.keys).to include('error')
    end
  end

  feature 'Create a new user with an invalid OTP and unregisterd phone number' do
    before do
      post :create, format: :json, params: {
        otp: 1,
        user: {
          phone_number: Faker::PhoneNumber.cell_phone_in_e164
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).not_to eq 201
      expect(response_status).to eq 401
      expect(response_json.keys).to include('error')
      expect(response_json['error']['code']).to eq 1002
    end
  end
end
