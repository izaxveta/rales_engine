class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def self.find_merchant(params)
    find_by(params)
  end

  def self.find_all_merchants(params)
    where(params)
  end

  def self.revenue(filter, limit = 1)
    Invoice
      .where(filter)
      .joins(:invoice_items, :transactions)
      .merge(Transaction.unscoped.successful)
      .limit(limit)
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def self.most_revenue(limit = 5)
    select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .joins(invoices: [:transactions, :invoice_items])
      .group(:id)
      .merge(Transaction.unscoped.successful)
      .order("revenue DESC")
      .limit(limit)
  end

  def self.most_items(filter)
    select("merchants.*, sum(invoice_items.quantity) as item_quantity")
      .joins(invoices: [:transactions, :invoice_items])
      .merge(Transaction.unscoped.successful)
      .group(:id)
      .order("item_quantity DESC")
      .limit(filter)
  end

  def self.favorite_customer(filter = nil)
    results = Invoice
      .where("invoices.merchant_id = #{filter}")
      .group('customer_id')
      .count
    Customer.find(results.key(results.values.max))
  end
end