class AddInitialCategories < ActiveRecord::Migration
  def up
    Category.create(name: 'Music')
    Category.create(name: 'Sports')
    Category.create(name: 'Gaming')
    Category.create(name: 'Education')
    Category.create(name: 'Movies')
    Category.create(name: 'TV Shows')
    Category.create(name: 'News')
  end

  def down
    Category.delete_all
  end
end
