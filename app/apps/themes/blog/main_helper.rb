module Themes::Blog::MainHelper
  def self.included(klass)
    klass.helper_method [:blog_get_nav_menu] rescue "" 
  end

  def blog_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  # callback called after theme installed
  def blog_on_install_theme(theme)
    blog_add_default_pages
    blog_add_fields_to_home_page
    blog_add_fields_to_about_us_page
    blog_add_fields_to_contact_us_page
    blog_add_blog_post_type
  end

  # callback executed after theme uninstalled
  def blog_on_uninstall_theme(theme)
  end

  def blog_add_default_pages
    page_post_type = current_site.the_post_type('page')
    if page_post_type.present?
      pages = ['Home Page', 'About Us', 'Contact Us']

      pages.each do |page|
        formatted_page = page.downcase.parameterize
        exist_page = current_site.the_post_type('page').the_posts.where("slug like '%#{formatted_page}%'")
        unless exist_page.present?
          page_post_type.add_post(title: page, content: 'lorem_ipsum')
        end
      end
    end
  end

  def blog_add_fields_to_home_page
    page = current_site.the_post_type('page').the_post('home-page')
    if page.get_field_groups.where(slug: '_group-blog-owner-s-detail').blank?
      blog_owner_detail_field = page.add_field_group({ name: "Blog Owner's Detail", slug: '_group-blog-owner-s-detail' })
      blog_owner_detail_field.add_field({ name: 'Name', slug: 'name' }, { field_key: 'text_box', required: true, default_value: "Owner's Name"})
      blog_owner_detail_field.add_field({ name: 'Job Title', slug: 'job-title' }, { field_key: 'text_box', required: true, default_value: "Owner's Job Title"})
      blog_owner_detail_field.add_field({ name: 'Avatar', slug: 'avatar' }, { field_key: 'image', required: true})
      blog_owner_detail_field.add_field({ name: 'Cover', slug: 'cover' }, { field_key: 'image', required: true})
    end
  end

  def blog_add_fields_to_about_us_page
    page = current_site.the_post_type('page').the_post('about-us')
    if page.get_field_groups.where(slug: '_group-blog-about-us').blank?
      blog_about_us_field = page.add_field_group({ name: "About Us", slug: '_group-blog-about-us' })

      blog_about_us_field.add_field({ name: 'First Section Label', slug: 'first-section-label' }, { field_key: 'text_box', required: true, default_value: "Experience"})
      blog_about_us_field.add_field({ name: 'First Section Description', slug: 'first-section-description' }, { field_key: 'editor', required: true, default_value: "Description"})

      blog_about_us_field.add_field({ name: 'Second Section Label', slug: 'second-section-label' }, { field_key: 'text_box', required: true, default_value: "Education"})
      blog_about_us_field.add_field({ name: 'Second Section Description', slug: 'second-section-description' }, { field_key: 'editor', required: true, default_value: "Description"})

      blog_about_us_field.add_field({ name: 'Third Section Label', slug: 'third-section-label' }, { field_key: 'text_box', required: true, default_value: "Accomplishment"})
      blog_about_us_field.add_field({ name: 'Third Section Description', slug: 'third-section-description' }, { field_key: 'editor', required: true, default_value: "Description"})
    end
  end

  def blog_add_fields_to_contact_us_page
    page = current_site.the_post_type('page').the_post('contact-us')
    if page.get_field_groups.where(slug: '_group-blog-owner-s-contact-information').blank?
      blog_contact_us_field = page.add_field_group({ name: "Blog Owner's Contact Information", slug: '_group-blog-owner-s-contact-information' })
      blog_content_us_field.add_field({ name: 'Facebook URL', slug: 'facebook-url'}, {field_key: 'url', required: 'true', default_value: "https://www.facebook.com/"})
      blog_content_us_field.add_field({ name: 'Twitter URL', slug: 'twitter-url'}, {field_key: 'url', required: 'false', default_value: "https://www.twitter.com/"})
      blog_content_us_field.add_field({ name: 'Google Plus URL', slug: 'google-plus-url'}, {field_key: 'url', required: 'false', default_value: "https://www.google.com/"})
      blog_content_us_field.add_field({ name: 'Email', slug: 'email'},{field_key: 'email', required: 'true', default_value: "@example.com"})
      blog_content_us_field.add_field({ name: 'First Phone Number', slug: 'first-phone-number'},{field_key: 'phone', required: 'true', default_value: "+855"})
      blog_content_us_field.add_field({ name: 'Second Phone Number', slug: 'second-phone-number'},{field_key: 'phone', required: 'true', default_value: "+855"})
    end
  end

  def blog_add_blog_post_type
    if current_site.the_post_type('blog-post').blank?
      blog_post = current_site.post_types.create(name: 'Blog Post', slug: 'blog-post')
      options = {
        has_category: true,
        has_content: true,
        has_tags: false,
        has_summary: false,
        has_comments: false,
        has_picture: false,
        has_template: false,
        has_keywords: false,
        contents_route_format: 'post_of_posttype'
      }
      blog_post.set_meta('_default', options)

      if blog_post.get_field_groups.where(slug: '_group-posts').blank?
        blog_post_field = blog_post.add_field_group({ name: "Blog Post", slug: '_group-posts' })
        blog_post_field.add_field({ name: 'Reference URL', slug: 'reference-url' }, { field_key: 'text_box', required: true, default_value: "https://www."})
        blog_post_field.add_field({ name: 'Image Content', slug: 'image-content' }, { field_key: 'image', required: true})
        blog_post_field.add_field({ name: "Author's Name", slug: "author-name" }, { field_key: 'text_box', required: true, default_value: "Mr./Mrs."})
        blog_post_field.add_field({ name: "Full Content", slug: "full-content" }, { field_key: 'editor', required: true, default_value: "Full Content For Posts"})
      end
    end
  end

  def blog_get_nav_menu(key = 'main_menu', class_name = "navigation")
    option = {
      menu_slug: key,
      container_class: class_name,
      container_id: 'main-menu-ul',
      item_class_parent: 'dropdown mega-dropdown',
      sub_class:        'dropdown-menu mega-dropdown-menu row',
      callback_item: lambda do |args|
        args[:link_attrs] = "data-title='#{args[:link][:name].parameterize}'"
        if args[:has_children]
          args[:settings][:after] = "<span class='dropdown-icon'><i class='fa fa-caret-down' aria-hidden='true'></i></span>"
          args[:link_attrs] += "data-toggle='dropdown'"
        end
      end
    }
    draw_menu(option)
  end
end
