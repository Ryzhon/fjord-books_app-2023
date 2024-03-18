# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books', type: :system do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    sign_in user
  end

  it '' do
    visit books_path
    expect(page).to have_selector 'h1', text: '本の一覧'
  end

  it 'creates a Book' do
    visit books_path
    click_on '本の新規作成'

    fill_in 'メモ', with: book.memo
    fill_in 'タイトル', with: book.title
    click_on '登録する'

    expect(page).to have_content '本が作成されました。'
    click_on '本の一覧に戻る'
  end

  it 'updates a Book' do
    visit book_path(book)
    click_on 'この本を編集', match: :first

    fill_in 'メモ', with: book.memo
    fill_in 'タイトル', with: book.title
    click_on '更新する'

    expect(page).to have_content '本が更新されました。'
    click_on '本の一覧に戻る'
  end

  it 'destroys a Book' do
    visit book_path(book)
    click_on 'この本を削除', match: :first

    expect(page).to have_content '本が削除されました。'
  end
end
