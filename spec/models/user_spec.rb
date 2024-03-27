# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, name: 'テストユーザー', email: 'test@example.com') }
  let(:other_user) { create(:user) }

  describe '#name_or_email' do
    context 'nameが存在する時' do
      it 'nameを返すこと' do
        expect(user.name_or_email).to eq(user.name)
      end
    end

    context 'nameが存在しない時' do
      it 'emailを返すこと' do
        user.name = ''
        expect(user.name_or_email).to eq(user.email)
      end
    end
  end
end
