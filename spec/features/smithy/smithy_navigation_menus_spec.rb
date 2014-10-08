require 'spec_helper'

describe "NavigationMenus", :type => :feature do
  include NavSteps
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
  before do
    set_nav_to(default_site_nav)
  end
  subject { render_page(home) }
  it { is_expected.to have_selector 'ul#nav' }
  it { is_expected.to have_selector 'ul#nav li', :count => 2 }
  it { is_expected.to have_selector 'li#nav-page-1'}
  it { is_expected.to have_selector 'li#nav-page-2'}


  context "using a depth of 2" do
    before do
      set_nav_to(site_nav_with_depth_of_2)
    end
    subject { render_page(home) }
    it { is_expected.to have_selector 'ul#nav' }
    it { is_expected.to have_selector 'ul#nav li', :count => 5 }
    it { is_expected.to have_selector 'li#nav-page-1'}
    it { is_expected.to have_selector 'li#nav-page-2'}
    it { is_expected.to have_selector 'li#nav-page-1-1'}
    it { is_expected.to have_selector 'li#nav-page-1-2'}
    it { is_expected.to have_selector 'li#nav-page-1-3'}
  end

  context "using a depth of 0" do
    before do
      set_nav_to(site_nav_with_depth_of_0)
    end
    subject { render_page(home) }
    it { is_expected.to have_selector 'ul#nav' }
    it { is_expected.to have_selector 'ul#nav li', :count => 6 }
    it { is_expected.to have_selector 'li#nav-page-1'}
    it { is_expected.to have_selector 'li#nav-page-2'}
    it { is_expected.to have_selector 'li#nav-page-1-1'}
    it { is_expected.to have_selector 'li#nav-page-1-2'}
    it { is_expected.to have_selector 'li#nav-page-1-3'}
    it { is_expected.to have_selector 'li#nav-page-1-3-1'}
  end

  context "on a subpage" do
    before do
      set_nav_to(default_site_nav)
    end
    subject { render_page(page1) }
    it { is_expected.to have_selector 'ul#nav' }
    it { is_expected.to have_selector 'ul#nav li', :count => 2 }
    it { is_expected.to have_selector 'li#nav-page-1'}
    it { is_expected.to have_selector 'li#nav-page-2'}
  end

  context "when using page nav" do
    before do
      set_nav_to(default_page_nav)
      page1.reload # the pages weren't reporting properly
    end
    subject { render_page(page1) }
    it { is_expected.to have_selector 'ul#nav' }
    it { is_expected.to have_selector 'ul#nav li', :count => 3 }
    it { is_expected.to have_selector 'li#nav-page-1-1'}
    it { is_expected.to have_selector 'li#nav-page-1-2'}
    it { is_expected.to have_selector 'li#nav-page-1-3'}
  end

  context "when using section nav" do
    before do
      set_nav_to(default_section_nav)
      page1.reload # the pages weren't reporting properly
    end
    subject { render_page(page1_3_1) }
    it { is_expected.to have_selector 'ul#nav' }
    it { is_expected.to have_selector 'ul#nav li', :count => 3 }
    it { is_expected.not_to have_selector 'li#nav-page-2'}
    it { is_expected.to have_selector 'li#nav-page-1-1'}
    it { is_expected.to have_selector 'li#nav-page-1-2'}
    it { is_expected.to have_selector 'li#nav-page-1-3'}
  end
end
