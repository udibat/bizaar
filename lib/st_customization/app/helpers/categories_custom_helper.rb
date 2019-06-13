module CategoriesCustomHelper
  def categories_for_select
    available_categories = CategoryViewUtils.category_tree(
        categories: Category.all,
        shapes: @current_community.shapes,
        locale: I18n.locale,
        all_locales: @current_community.locales
      )
    [[nil, nil]] + available_categories.map{|h| [h[:label], h[:id]]}
  end
end

