require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    it "returns an empty array if there are no videos in this category" do
      Video.create(title: "Family Guy", description: "A cartoon.")
      category = Category.create(name: "Comedies")

      expect(category.recent_videos).to eq([])
    end

    it "returns all videos in this category if their total is less than or equal to six (ordered reverse chrono)" do
      category = Category.create(name: "Comedies")
      v4 = Video.create(title: "b", description: "x", created_at: 4.day.ago, category: category)
      v1 = Video.create(title: "a", description: "x", created_at: 1.day.ago, category: category)
      v3 = Video.create(title: "c", description: "x", created_at: 3.day.ago, category: category)
      v2 = Video.create(title: "d", description: "x", created_at: 2.day.ago, category: category)
      Video.create(title: "x", description: 'x')

      expect(category.recent_videos).to eq([v1, v2, v3, v4])
    end

    it "returns the six most recent (ie, reverse chrono order) videos in this category" do
      comedy = Category.create(name: "Comedies")
      drama = Category.create(name: "Dramas")

      Video.create(title: "c", description: "x", created_at: 7.day.ago, category: comedy)
      v6 = Video.create(title: "d", description: "x", created_at: 6.day.ago, category: comedy)
      v5 = Video.create(title: "e", description: "x", created_at: 5.day.ago, category: comedy)
      v4 = Video.create(title: "f", description: "x", created_at: 4.day.ago, category: comedy)
      v1 = Video.create(title: "g", description: "x", created_at: 1.day.ago, category: comedy)
      v3 = Video.create(title: "a", description: "x", created_at: 3.day.ago, category: comedy)
      v2 = Video.create(title: "b", description: "x", created_at: 2.day.ago, category: comedy)
      Video.create(title: "x", description: 'x', category: drama)

      expect(comedy.recent_videos).to eq([v1, v2, v3, v4, v5, v6])
    end
  end
end

