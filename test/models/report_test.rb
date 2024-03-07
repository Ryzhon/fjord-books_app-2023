# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @report = @user.reports.build(title: 'テスト日報', content: '日報の内容をここに記載する。')
  end

  test '保存される' do
    assert @report.valid?
  end

  test 'タイトルがないとエラーになる' do
    @report.title = ''
    assert_not @report.valid?
  end

  test '内容がないとエラーになる' do
    @report.content = ''
    assert_not @report.valid?
  end

  test '作成したユーザーが編集することができる' do
    assert @report.editable?(@user)
  end

  test '作成していないユーザーは編集することができない' do
    other_user = users(:two)
    assert_not @report.editable?(other_user)
  end

  test '関連するコメントも一緒に削除される' do
    @report.save
    @report.comments.create!(content: 'テストコメント', user: @user)

    assert_difference 'Report.count', -1 do
      assert_difference 'Comment.count', -1 do
        @report.destroy
      end
    end
  end

  test 'created_onで曜日の形式を変更する' do
    @report.created_at = Time.zone.now
    assert_equal @report.created_on, Time.zone.today
  end

  test 'save_mentionsでコンテントから日報のメンションを保存できている' do
    mentioned_report1 = @user.reports.create!(title: 'メンションされるレポート1', content: 'これはテストレポートです。')
    mentioned_report2 = @user.reports.create!(title: 'メンションされるレポート2', content: 'これもテストレポートです。')

    @report.content = "これはテストです。メンションされるレポートはこちらです: http://localhost:3000/reports/#{mentioned_report1.id} と http://localhost:3000/reports/#{mentioned_report2.id}"

    assert_difference 'ReportMention.count', 2 do
      @report.save
    end

    assert_includes @report.mentioning_reports, mentioned_report1
    assert_includes @report.mentioning_reports, mentioned_report2
  end
end
