require 'test_helper'

class ArticlesTest < Test::Unit::TestCase
  context('When an category has articles') do
    setup do
      @category = Factory(:category, :title => 'My filled up category')
      4.times do
        Factory(:article, :category => @category)
      end
    end
    
    should 'not be able to delete it' do
      @category.destroy
      assert_valid(Category.find_by_id(@category.id))
    end
  end
  
  context('When an category has no articles') do
    setup do
      @category = Factory(:category, :title => 'My empty category')
    end
    
    should 'be able to delete it' do
      @category.destroy
      assert_nil(Category.find_by_id(@category.id))
    end
  end
end
