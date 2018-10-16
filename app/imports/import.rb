class Import
  include ActiveModel::Model
  attr_accessor :file, :model_type

  def initialize attributes = {}
    attributes.each{|name, value| send("#{name}=", value)}
  end
  
  def save
    #Chỉ cho phép import file dạng CSV
    unless File.extname(file.original_filename) == ".csv"
      errors.add :base, "import.unknown_file_type"
      return
    end
    spreadsheet = Roo::Spreadsheet.open file.path
    header = spreadsheet.row 1
    header_model = model_type.constantize.column_names
    # Kiểm tra nếu file csv lấy vào ko khớp với model được chọn
    unless (header -  header_model).empty?
      errors.add :base, "File CSV does not match. Pls try again!"
      return
    end
    load_imported_master header, spreadsheet
  end

  def load_imported_master header, spreadsheet
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |i|
        binding.pry
        row = Hash[[header, spreadsheet.row(i)].transpose]
        object = master_type.constantize.find_by(id: row["id"]) || master_type.constantize.new
        object.attributes = row.to_hash
        if object.valid?
            object.save!
        else
          object.errors.messages.each do |_key, message|
            errors.add :base, "#{message}"
          end
        end
        raise ActiveRecord::Rollback
      end
    end
  end

  # def persisted?
  #   false
  # end

  # def save
  #   if imported_orders.map(&:valid?).all?
  #     imported_orders.each(&:save!)
  #     true
  #   else
  #     imported_orders.each_with_index do |order, index|
  #       order.errors.full_messages.each do |message|
  #         errors.add :base, "Row #{index+2}: #{message}"
  #       end
  #     end
  #     false

  #   end
  # end

  # def imported_orders
  #   @imported_orders ||= load_imported_orders
  # end

  # def load_imported_orders
  #   spreadsheet = Roo::Spreadsheet.open(file.path)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     order = Order.find_by(id: row["id"]) || Order.new
  #     order.attributes = row.to_hash
  #     order
  #   end    
  # end
end
    