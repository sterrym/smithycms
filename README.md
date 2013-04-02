# Smithy CMS

## Templates & Includes
These are the building blocks of a page. All the markup is written using the Liquid templating engine. This allows anyone to be able to write templates without the dangers of exposing the whole stack to the template editor.

## Pages
On top of its own innate elements (title, permalink, etc), each page belongs to a template and through the template, has a set of available content containers. To each container, pieces of content can be added and organized via various "Content Blocks".

## Content Blocks
A "Content Block" is simply an ActiveRecord model with a Smithy inclusion (<code>include Smithy::ContentBlocks::Model</code>), a <code>_form_fields</code> partial (preferably utilizing formtastic) and it's own set of templates, managed within Smithy.

## Getting Started
To get started, add this to your Gemfile

```ruby
gem 'smithy', :github => 'sterrym/smithy'
```

Installing the CMS is simple, you can just

```shell
bundle install
rake smithy:install:migrations
rake db:migrate
```

To your routes file, you need to mount Smithy - typically, this would be done at the root

```ruby
mount Smithy::Engine => "/"
```

Now start up your server and go to http://localhost:nnnn/smithy/templates

### Templates

Create your first Template, naming it whatever you want ("Home" or "Default" or something equally original). In the content, add `{{ page.container.main_content }}`. In the background, this will auto-create a container that will be used by any page using your template. You can name your container whatever you would like: `{{ page.container.foo }}` works as well.

If you want, you can create Includes. For instance, if you create an Include named "header", you can utilize it in your Template via `{% include 'header' %}`.

Note, you can also create stylesheet and javascript files, included in your templates via smithy_stylesheet_link_tag and smithy_javascript_include_tag. javascript_include_tag calls out directly to ActionView so you can also access files from your host application directly. Eg. `{% smithy_javascript_include_tag 'my_special_javascript' %}`

### Pages

Follow the "Manage Content" link in the header and create your first page. Add a Title ("Home" for instance), select your Template and save the page. The page will save and you will be on the Edit screen for your new page. You can see that your "Main Content" container is now available.

### Content Blocks

Smithy comes with some useful Content Blocks already created, though you may need to add them to your system: Content, Image, PageList. After adding a Content Block, you must also create at least one template for it before you can use it on a page. Once you have added a template, you can utilize that Content Block in any available Page container.
