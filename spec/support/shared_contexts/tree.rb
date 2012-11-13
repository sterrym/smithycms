shared_context "a tree of pages" do
  let!(:home) { FactoryGirl.create(:page, :title => "Home") }
  let!(:page1) { FactoryGirl.create(:page, :title => "Page 1", :parent => home) }
  let!(:page1_1) { FactoryGirl.create(:page, :title => "Page 1-1", :parent => page1) }
  let!(:page1_2) { FactoryGirl.create(:page, :title => "Page 1-2", :parent => page1) }
  let!(:page1_3) { FactoryGirl.create(:page, :title => "Page 1-3", :parent => page1) }
  let!(:page1_3_1) { FactoryGirl.create(:page, :title => "Page 1-3-1", :parent => page1_3) }
  let!(:page2) { FactoryGirl.create(:page, :title => "Page 2", :parent => home) }
  let!(:page2_1) { FactoryGirl.create(:page, :title => "Page 2-1", :parent => page2) }
  let!(:page2_2) { FactoryGirl.create(:page, :title => "Page 2-2", :parent => page2) }
  let!(:page3) { FactoryGirl.create(:page, :title => "Page 3", :parent => home) }
end
