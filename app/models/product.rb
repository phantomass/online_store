class Product < ActiveRecord::Base
  has_many :line_items
  belongs_to :category
  has_attached_file :photo,
    :storage => :s3,
    :bucket => 'gilf-ilnur.tk',
    :path => ":attachment/:id/:style.:extension",
    :s3_credentials => "#{Rails.root}/config/s3.yml"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true, length: { maximum: 15 }


  def self.latest
    Product.order(:updated_at).last
  end

  private

  # убеждаемся в отсутствии товарных позиций, ссылающихся на данный товар
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют товарные позиции')
      return false
    end
  end

end