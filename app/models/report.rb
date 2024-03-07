# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioning_mentions, class_name: 'Mention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioned_reports, through: :mentioning_mentions, source: :mentioned_report
  has_many :mentioned_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioning_reports, through: :mentioned_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :update_mentions
  after_destroy :remove_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def update_mentions
    current_mentioned_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten
    existing_mentioned_ids = mentioned_reports.pluck(:id).map(&:to_s)

    (current_mentioned_ids - existing_mentioned_ids).each do |id|
      mentioned_report = Report.find_by(id:)
      mentioning_mentions.create(mentioned_report:) if mentioned_report
    end

    (existing_mentioned_ids - current_mentioned_ids).each do |id|
      mentioned_report = Report.find_by(id:)
      mentioning_mentions.find_by(mentioned_report_id: mentioned_report.id).destroy if mentioned_report
    end
  end

  def remove_mentions
    mentioning_mentions.destroy_all
    mentioned_mentions.destroy_all
  end
end
