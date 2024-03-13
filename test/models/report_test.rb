# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @report = @user.reports.build(title: 'テスト日報', content: '日報の内容をここに記載する。')
  end

  test '作成したユーザーが編集することができる' do
    assert @report.editable?(@user)
  end

  test '作成していないユーザーは編集することができない' do
    other_user = users(:two)
    assert_not @report.editable?(other_user)
  end

  test 'created_onで曜日の形式を変更する' do
    current_time = Time.zone.now
    @report.created_at = current_time
    assert_equal @report.created_on, current_time.to_date
  end

  test 'save_mentionsでcontentから日報のメンションを保存できている' do
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
