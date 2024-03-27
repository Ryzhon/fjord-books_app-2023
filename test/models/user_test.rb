# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test 'name_or_email関数はnameが存在するか、emailを返す' do
    assert_equal @user.name_or_email, @user.name.presence || @user.email
    @user.name = ''
    assert_equal @user.name_or_email, @user.email
  end
end
