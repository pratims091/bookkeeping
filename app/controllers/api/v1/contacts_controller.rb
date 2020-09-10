# frozen_string_literal: true

module Api
  module V1
    class ContactsController < Api::V1::ApiController
      def index
        contacts = @current_user.contacts
        # @TODO: filter and pagination
        render json: { contacts: serialize(contacts) }, status: :ok
      end

      def create
        param! :contact, Hash, required: true do |c|
          c.param! :name, String, required: false
          c.param! :phone_number, String, required: true
        end

        contact = @current_user.contacts.new contact_params

        if contact.valid?
          contact.save!
          render json: { contact: serialize(contact) }, status: :created
        else
          render json: { error: contact.errors.full_messages.join(',') }, status: :unprocessable_entity
        end
      end

      private

      def contact_params
        params.require(:contact).permit(:name, :phone_number)
      end
    end
  end
end
