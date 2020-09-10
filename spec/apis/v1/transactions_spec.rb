# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:response_json) { JSON.parse(response.body) }
  let(:response_status) { response.status }
  let!(:user1) { create(:user) }
  let!(:user1_contact1) { create(:contact, user: user1) }
  let!(:user1_contact2) { create(:contact, user: user1) }
  let!(:user1_transaction1) { create(:transaction, transaction_type: 'credit', user: user1) }
  let!(:user1_transaction2) { create(:transaction, transaction_type: 'credit', user: user1, contact: user1_contact1) }
  let!(:user1_transaction3) { create(:transaction, transaction_type: 'debit', user: user1, contact: user1_contact2) }
  let!(:user2) { create(:user) }
  let!(:user2_contact1) { create(:contact, user: user2) }
  let!(:user2_contact2) { create(:contact, user: user2) }
  let!(:user2_transaction1) { create(:transaction, transaction_type: 'credit', user: user2) }
  let!(:user2_transaction2) { create(:transaction, transaction_type: 'debit', user: user2, contact: user2_contact1) }
  let!(:user2_transaction3) { create(:transaction, transaction_type: 'debit', user: user2, contact: user2_contact2) }

  feature 'Authorized user transactions list without filter and pagination' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json
    end

    scenario 'Should get only their transactions' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].length).to eq user1.transactions.count
      expect(response_json['transactions'].map { |t| t['id'] }).to eq user1
        .transactions.order(happend_on: :desc).pluck(:id)
    end
    scenario 'Should not get other users transactions' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].map { |t| t['id'] }).not_to eq user2.transactions.pluck(:id)
    end
  end

  feature 'Authorized user transactions list order by recency' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json
    end

    scenario 'Should get only their transactions' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].length).to eq user1.transactions.count
      expect(response_json['transactions'].map { |t| t['id'] }).to eq user1
        .transactions.order(happend_on: :desc).pluck(:id)
    end
  end

  feature 'Authorized user transactions filter by transaction_type' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json, params: { transaction_type: 'credit' }
    end

    scenario 'Should get only credit transactions' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].length).to eq user1.transactions.credit.count
    end
  end

  feature 'Authorized user transactions filter by contact_id' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json, params: { contact_id: user1_contact1.id }
    end

    scenario 'Should get only credit transactions' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].length).to eq user1.transactions.where(contact_id: user1_contact1.id).count
    end
  end

  feature 'Authorized user transactions list with pagination' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      get :index, format: :json, params: { page: 1, per_page: 1 }
    end

    scenario 'Should get only one record per page' do
      expect(response_status).to eq 200
      expect(response_json.keys).to include('transactions')
      expect(response_json['transactions'].length).to eq 1
    end
  end

  feature 'Authorized user create transactions with required params and without optional params' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      post :create, format: :json, params: {
        transaction: {
          transaction_type: 'credit',
          amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
          happend_on: Date.yesterday
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('transaction')
      expect(response_json['transaction']['transaction_type']).to eq 'credit'
      user1.transactions.reload
      expect(user1.transactions.count).to eq 4
    end
  end
  feature 'Authorized user create transactions without required params' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      post :create, format: :json, params: {
        transaction: {
          amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
          happend_on: Date.yesterday,
          comments: Faker::DcComics.hero,
          contact_id: user1_contact1.id
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 422
      expect(response_json.keys).not_to include('transaction')
      expect(response_json.keys).to include('error')
      user1.transactions.reload
      expect(user1.transactions.count).to eq 3
    end
  end

  feature 'Authorized user create transactions of their contact' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      post :create, format: :json, params: {
        transaction: {
          transaction_type: 'debit',
          amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
          happend_on: Date.yesterday,
          comments: Faker::DcComics.hero,
          contact_id: user1_contact1.id
        }
      }
    end

    scenario 'Should succed' do
      expect(response_status).to eq 201
      expect(response_json.keys).to include('transaction')
      user1.transactions.reload
      expect(user1.transactions.count).to eq 4
      expect(user1.transactions.last.contact.id).to eq user1_contact1.id
    end
  end

  feature 'Authorized user create transactions not of their contact' do
    before do
      token = AuthenticationService.generate_authentication_token(user1)
      request.headers['Authorization'] = token
      post :create, format: :json, params: {
        transaction: {
          transaction_type: 'debit',
          amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
          happend_on: Date.yesterday,
          comments: Faker::DcComics.hero,
          contact_id: user2_contact1.id
        }
      }
    end

    scenario 'Should not succed' do
      expect(response_status).to eq 422
      expect(response_json.keys).not_to include('transaction')
      user1.transactions.reload
      expect(user1.transactions.count).to eq 3
    end
  end
end
