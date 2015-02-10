# place this file in your plugins directory and add the tag to your sidebar
#$ cat source/_includes/custom/asides/categories.html 
#<section>
#  <h1>Categories</h1>
#  <ul id="categories">
#    {% category_list %}
#  </ul>
#</section>
# 
# http://blog.nistu.de/2011/08/14/a-category-list-generator-for-jekyll 
# 
module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""

context.registers[:site].categories.keys

      html < @site.post
    end
  end
end
 
Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)
