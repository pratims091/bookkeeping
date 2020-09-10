# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  let(:response_json) { JSON.parse(response.body) }
  let(:response_status) { response.status }
  let!(:user1) { create(:user) }
  let!(:user1_contact1) { create(:contact, user: user1) }
  let!(:user1_contact2) { create(:contact, user: user1) }
  let!(:user1_contact3) { create(:contact, user: user1) }
  let!(:user1_contact4) { create(:contact, user: user1) }
  let!(:user2) { create(:user) }
  let!(:user2_contact1) { create(:contact, user: user2) }
  let!(:user2_contact2) { create(:contact, user: user2) }
  let!(:user2_contact3) { create(:contact, user: user2) }
  let!(:user2_contact4) { create(:contact, user: user2) }

  feature 'Authorized user contact list' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json
    end

    scenario 'Should get only their contacts' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('contacts')
      expect(response_json['contacts'].length).to eq user1.contacts.count
      expect(response_json['contacts'].map { |c| c['id'] }).to eq user1.contacts.pluck(:id)
    end
    scenario 'Should not get other users contacts' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('contacts')
      expect(response_json['contacts'].map { |c| c['id'] }).not_to eq user2.contacts.pluck(:id)
    end
  end

  feature 'Unauthorized user contact list' do
    before do
      get :index, format: :json
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 401
      expect(response_json.keys).not_to include('contacts')
    end
  end

  feature 'Authorized user create contact' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :create, format: :json, params: {
        contact: {
          phone_number: Faker::PhoneNumber.cell_phone_in_e164,
          name: Faker::Name.name
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('contact')
      user1.contacts.reload
      expect(user1.contacts.count).to eq 5
    end
  end

  feature 'Authorized user create contact without name' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :create, format: :json, params: {
        contact: {
          phone_number: Faker::PhoneNumber.cell_phone_in_e164
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('contact')
      user1.contacts.reload
      expect(user1.contacts.count).to eq 5
    end
  end

  feature 'Authorized user create contact without phone number' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :create, format: :json, params: {
        contact: {
          name: Faker::Name.name
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 422
      expect(response_json.keys).not_to include('contact')
      user1.contacts.reload
      expect(user1.contacts.count).to eq 4
      expect(response_json['error']['code']).to eq 1004
    end
  end

  feature 'Authorized user create contact with phone number already present in their contact' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :create, format: :json, params: {
        contact: {
          name: user1_contact1.name,
          phone_number: user1_contact1.phone_number
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 422
      expect(response_json.keys).not_to include('contact')
      user1.contacts.reload
      expect(user1.contacts.count).to eq 4
    end
  end

  feature 'Authorized user create contact with phone number already present in contact but not in their contact' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :create, format: :json, params: {
        contact: {
          name: user2_contact1.name,
          phone_number: user2_contact1.phone_number
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('contact')
      user1.contacts.reload
      expect(user1.contacts.count).to eq 5
      expect(response_json['contact']['phone_number']).to eq user2_contact1.phone_number
    end
  end
end
