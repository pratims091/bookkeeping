# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < Api::V1::ApiController
      def create
        param! :transaction, Hash, required: true do |t|
          t.param! :transaction_type, String, required: false, in: Transaction::VALID_TRANSACTION_TYPES
          t.param! :amount, BigDecimal, precision: 2, required: true
          t.param! :happend_on, Date, required: true
          t.param! :comments, String, required: false
          t.param! :contact_id, Integer, required: false
        end
        transaction = @current_user.transactions.new transaction_params

        if transaction.valid?
          transaction.save!
          render json: { transaction: serialize(transaction) }, status: :created
        else
          render json: { errors: transaction.errors.messages }, status: :unprocessable_entity
        end
      end

      def index
        param! :transaction_type, String, required: false, in: Transaction::VALID_TRANSACTION_TYPES
        param! :contact_id, Integer, required: false
        param! :page, Integer, required: false, default: 1
        param! :per_page, Integer, required: false, default: 10

        ransack = {}
        ransack[:transaction_type_eq] = params[:transaction_type] if params[:transaction_type].present?
        ransack[:contact_id_eq] = params[:contact_id] if params[:contact_id].present?
        # Filter by contact phone number

        transactions = @current_user.transactions.ransack(ransack)
        transactions = transactions.result.order(happend_on: :desc)
        total = transactions.count
        transactions = transactions.page(params[:page]).per(params[:per_page])

        render json: {
          transactions: serialize(transactions),
          meta: {
            total: total,
            page: params[:page],
            per_page: params[:per_page]
          }
        }, status: :ok
      end

      private

      def transaction_params
        params.require(:transaction).permit(:transaction_type, :amount, :happend_on, :comments, :contact_id)
      end
    end
  end
end
