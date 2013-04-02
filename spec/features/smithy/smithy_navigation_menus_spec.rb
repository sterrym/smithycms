require 'spec_helper'

describe "NavigationMenus" do
  include NavSteps
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
  before do
    set_nav_to(default_site_nav)
  end
  subject { render_page(home) }
  it { should have_selector 'ul#nav' }
  it { should have_selector 'ul#nav li', :count => 2 }
  it { should have_selector 'li#nav-page-1'}
  it { should have_selector 'li#nav-page-2'}


  context "using a depth of 2" do
    before do
      set_nav_to(site_nav_with_depth_of_2)
    end
    subject { render_page(home) }
    it { should have_selector 'ul#nav' }
    it { should have_selector 'ul#nav li', :count => 5 }
    it { should have_selector 'li#nav-page-1'}
    it { should have_selector 'li#nav-page-2'}
    it { should have_selector 'li#nav-page-1-1'}
    it { should have_selector 'li#nav-page-1-2'}
    it { should have_selector 'li#nav-page-1-3'}
  end

  context "using a depth of 0" do
    before do
      set_nav_to(site_nav_with_depth_of_0)
    end
    subject { render_page(home) }
    it { should have_selector 'ul#nav' }
    it { should have_selector 'ul#nav li', :count => 6 }
    it { should have_selector 'li#nav-page-1'}
    it { should have_selector 'li#nav-page-2'}
    it { should have_selector 'li#nav-page-1-1'}
    it { should have_selector 'li#nav-page-1-2'}
    it { should have_selector 'li#nav-page-1-3'}
    it { should have_selector 'li#nav-page-1-3-1'}
  end

  context "on a subpage" do
    before do
      set_nav_to(default_site_nav)
    end
    subject { render_page(page1) }
    it { should have_selector 'ul#nav' }
    it { should have_selector 'ul#nav li', :count => 2 }
    it { should have_selector 'li#nav-page-1'}
    it { should have_selector 'li#nav-page-2'}
  end

  context "when using page nav" do
    before do
      page1.reload # the rgt/lft columns were reporting incorrectly
      set_nav_to(default_page_nav)
    end
    subject { render_page(page1) }
    it { should have_selector 'ul#nav' }
    it { should have_selector 'ul#nav li', :count => 3 }
    it { should have_selector 'li#nav-page-1-1'}
    it { should have_selector 'li#nav-page-1-2'}
    it { should have_selector 'li#nav-page-1-3'}
  end
end
