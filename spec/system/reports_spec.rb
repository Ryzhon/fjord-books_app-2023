# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  let(:user) { create(:user) }
  let(:report) { create(:report, user:) }

  before do
    sign_in user # Deviseのヘルパーメソッドを使用
  end

  it 'visits the index' do
    visit reports_path
    expect(page).to have_selector 'h1', text: '日報の一覧'
  end

  it 'creates a report' do
    visit reports_path
    click_on '日報の新規作成'

    fill_in 'タイトル', with: report.title
    fill_in '内容', with: report.content
    click_on '登録する'

    expect(page).to have_content '日報が作成されました。'
    expect(page).to have_content report.title
    expect(page).to have_content report.content
    click_on '日報の一覧に戻る'
  end

  it 'updates a report' do
    updated_title = '更新されたタイトル'
    updated_content = '更新された内容'

    visit report_path(report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: updated_title
    fill_in '内容', with: updated_content
    click_on '更新する'

    expect(page).to have_content '日報が更新されました。'
    expect(page).to have_content updated_title
    expect(page).to have_content updated_content
    click_on '日報の一覧に戻る'
  end

  it 'destroys a report' do
    visit report_path(report)
    click_on 'この日報を削除', match: :first

    expect(page).to have_content '日報が削除されました。'
    expect(page).not_to have_content report.title
    expect(page).not_to have_content report.content
  end
end
