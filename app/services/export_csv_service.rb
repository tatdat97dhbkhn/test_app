class ExportCsvService
  require "csv"

  def initialize objects, attributes
    @attributes = attributes
    @objects = objects
    @header = attributes.map { |attr| "#{attr}" }
  end

  def perform
    
    CSV.generate do |csv|
      csv << header
      objects.each do |object|
        csv << [
          object.name,
          object.unit_price,
          object.quantity,
          object.order.order_number
        ]
      end
    end
  end

  private
  attr_reader :attributes, :objects, :header
end
