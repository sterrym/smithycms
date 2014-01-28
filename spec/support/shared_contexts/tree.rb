shared_context "a tree of pages" do
  let!(:home) { create(:page, :title => "Home") }
  let!(:page1) { create(:page, :title => "Page 1", :parent => home, :publish => true) }
  let!(:page1_1) { create(:page, :title => "Page 1-1", :parent => page1, :publish => true) }
  let!(:page1_2) { create(:page, :title => "Page 1-2", :parent => page1, :publish => true) }
  let!(:page1_3) { create(:page, :title => "Page 1-3", :parent => page1, :publish => true) }
  let!(:page1_3_1) { create(:page, :title => "Page 1-3-1", :parent => page1_3, :publish => true) }
  let!(:page2) { create(:page, :title => "Page 2", :parent => home, :publish => true) }
  let!(:page2_1) { create(:page, :title => "Page 2-1", :parent => page2, :show_in_navigation => false, :publish => true) }
  let!(:page2_2) { create(:page, :title => "Page 2-2", :parent => page2, :publish => false) }
  let!(:page3) { create(:page, :title => "Page 3", :parent => home, :publish => false, :show_in_navigation => false) }
  let!(:page4) { create(:page, :title => "Page 4", :parent => home, :published_at => 1.day.from_now) }
end
