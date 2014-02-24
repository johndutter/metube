class CategoriesController < ApplicationController
  def get_categories
    if categories = Category.find(:all)
      category_arr = Array.new
      categories.each do |category|
        category_arr.push(category[:name])
      end
      render :json => {categories: category_arr}, status: :ok
    else
      render :json => {categories: []}, status: :bad_request
    end
  end
end
