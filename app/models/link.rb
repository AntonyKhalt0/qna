class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
  validates :url, format: { with: /\A#{URI::regexp(['http', 'https'])}\z/, message: "Invalid URL" }

  def gist?
    url =~ /https*:\/\/gist.github.com\/\w+/
  end
end
