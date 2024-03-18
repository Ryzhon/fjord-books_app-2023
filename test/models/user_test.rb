# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'ユーザーがバリデーションを通っている' do
    assert @user.valid?
  end

  test 'メールアドレスがないとエラーになる' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'メールアドレスがユニークであってはいけない' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'ユーザーが削除された時、ユーザーに関連している日報は削除される' do
    @user.save
    @user.destroy
    assert_equal 0, Report.where(user_id: @user.id).count
  end
  test 'name_or_email関数はnameが存在するか、emailを返す' do
    assert_equal @user.name_or_email, @user.name.presence || @user.email
    @user.name = ''
    assert_equal @user.name_or_email, @user.email
  end
end
