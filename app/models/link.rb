# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, message: 'Invalid URL' }

  def gist?
    url =~ %r{https*://gist.github.com/\w+}
  end
end
