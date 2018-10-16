class ImportsController < ApplicationController
  # def new
  #   @import = Import.new
  # end

  def create
    @import = Import.new(params[:import])
    if @import.save
      redirect_back fallback_location: root_path, notice: "Imported successfully."
    else
      redirect_to orders_path
    end
  end
end
