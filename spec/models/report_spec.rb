# frozen_string_literal: true

# spec/models/report_spec.rb
require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user) { create(:user, email: 'testA@example.com') }
  let(:other_user) { create(:user, email: 'testB@example.com') }
  let(:report) { create(:report, user:, title: 'テスト日報', content: '日報の内容をここに記載する。') }

  describe '#editable?' do
    context '作成したユーザーの時' do
      it '編集できること' do
        expect(report).to be_editable(user)
      end
    end

    context '作成していないユーザーの時' do
      it '編集できないこと' do
        expect(report).not_to be_editable(other_user)
      end
    end
  end

  describe '#created_on' do
    it 'created_onで曜日の形式を変更する' do
      current_time = Time.zone.now
      report.update(created_at: current_time)
      expect(report.created_on).to eq(current_time.to_date)
    end
  end

  describe '#save_mentions' do
    let!(:mentioned_report1) { create(:report, user:, title: 'メンションされるレポート1', content: 'これはテストレポートです。') }
    let!(:mentioned_report2) { create(:report, user:, title: 'メンションされるレポート2', content: 'これもテストレポートです。') }

    it 'save_mentionsでcontentから日報のメンションを保存できること' do
      report.content = "これはテストです。メンションされるレポートはこちらです: http://localhost:3000/reports/#{mentioned_report1.id} と http://localhost:3000/reports/#{mentioned_report2.id}"
      expect { report.save }.to change { ReportMention.count }.by(2)
      expect(report.mentioning_reports).to include(mentioned_report1, mentioned_report2)
    end

    context 'contentが更新されたとき' do
      let!(:new_mentioned_report) { create(:report, user:, title: '新しくメンションされるレポート', content: '新しいテストレポートです。') }

      before do
        report.content = "これはテストです。メンションされるレポートはこちらです: http://localhost:3000/reports/#{mentioned_report1.id} と http://localhost:3000/reports/#{mentioned_report2.id}"
        report.save
      end

      it '更新する時に追加されるか' do
        report.content = "内容が更新されました。新しいメンション: http://localhost:3000/reports/#{new_mentioned_report.id}"
        expect { report.save }.to change { ReportMention.count }.by(-1)
        report.reload
        expect(report.mentioning_reports).not_to include(mentioned_report1, mentioned_report2)
        expect(report.mentioning_reports).to include(new_mentioned_report)
      end
    end
  end
end
