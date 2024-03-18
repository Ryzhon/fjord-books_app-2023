# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in '内容', with: @report.content
    fill_in 'タイトル', with: @report.title
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text @report.title
    assert_text @report.content
    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    updated_title = '更新されたタイトル'
    updated_content = '更新された内容'
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in '内容', with: updated_title
    fill_in 'タイトル', with: updated_content
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text updated_title
    assert_text updated_content
    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_no_text @report.title
    assert_no_text @report.content
  end
end
