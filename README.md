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

If you need basic authentication and don't want to integrate with existing auth in your system, add this to your Gemfile too:
gem 'smithy-auth', :github => 'sterrym/smithy-auth'

Installing the CMS is simple, you can just

```shell
bundle install
rake smithy:install:migrations
rake smithy_auth:install:migrations # (if you are using smithy-auth)
rake db:migrate
```

To your routes file, you need to mount Smithy - typically, this would be done at the root

```ruby
mount Smithy::Engine => "/"
```

Now start up your server and go to http://localhost:nnnn/smithy

## Integrating with third-party authentication

Add this to your routes file (below the `mount Smithy::Engine` line). It will redirect smithy/login|logout (the built-in paths) to your existing authentication paths.

```ruby
scope "/smithy" do
  match "/login" => redirect("/your/login/path"), :as => :login
  match '/logout' => redirect("/"), :as => :logout
end
```

Add the following to your application controller:

```ruby
def smithy_current_user
  current_user # use whichever method name you have implemented to return the current_user
end
helper_method :smithy_current_user
```

If you wish for all of your users to have access to smithy, simply add this method to your user model:

```ruby
def smithy_admin?
  true
end
```

Alternatively, you can add a boolean field (via migration) named `smithy_admin` to your users table and manage the field with with your existing user management.

Restart your local server and you should be good to go.

### Templates

Create your first Template, naming it whatever you want ("Home" or "Default" or something equally original). In the content, add `{{ page.container.main_content }}`. In the background, this will auto-create a container that will be used by any page using your template. You can name your container whatever you would like: `{{ page.container.foo }}` works as well. After you have created new page containers, they will automatically show up on the Page edit screen and allow you to add content to the container.

If you want, you can create Includes. For instance, if you create an Include named "header", you can utilize it in your Template via `{% include 'header' %}`.

Note, you can also create stylesheet and javascript files, included in your templates via smithy_stylesheet_link_tag and smithy_javascript_include_tag. javascript_include_tag calls out directly to ActionView so you can also access files from your host application directly. Eg. `{% smithy_javascript_include_tag 'my_special_javascript' %}`

### Pages

Follow the "Manage Content" link in the header and create your first page. Add a Title ("Home" for instance), select your Template and save the page. The page will save and you will be on the Edit screen for your new page. You can see that your "Main Content" container is now available.

### Content Blocks

Smithy comes with some useful Content Blocks already created, though you may need to add them to your system: Content, Image, PageList. After adding a Content Block, you must also create at least one template for it before you can use it on a page. Once you have added a template, you can utilize that Content Block in any available Page container.
