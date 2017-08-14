require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#recent_reviews' do
    let(:video) { Fabricate(:video) }
    subject { video.recent_reviews }

    it "returns an empty array if there are no reviews" do
      expect(subject).to eq([])
    end

    it "returns reviews in reverse chronological order (ie, newest first)" do
      reviews = 4.times.map do |i|
        Fabricate(:review, video: video, created_at: i.day.ago)
      end
      expect(subject).to eq(reviews)
    end

    it "returns the 8 most recent reviews for this video" do
      reviews = 10.times.map do |i|
        Fabricate(:review, video: video, created_at: i.day.ago)
      end
      expect(subject).to eq(reviews.first(8))
    end
  end

  describe '#average_rating' do
    let (:video) { Fabricate(:video) }
    subject { video.average_rating }

    it "returns 0 if there are no reviews" do
      expect(subject).to eq(0)
    end

    it "returns the value of the review if there is only 1 review" do
      review = Fabricate(:review, video: video)
      expect(subject).to eq(review.rating)
    end

    it "returns a floating point value for the review" do
      Fabricate(:review, video: video, rating: 4)
      Fabricate(:review, video: video, rating: 5)
      expect(subject).to eq(4.5)
    end

    it "returns the (floating point) average of all reviews" do
      ratings = 10.times.map do |i|
        Fabricate(:review, video: video).rating
      end

      ave_rating = ratings.reduce(:+).to_f / ratings.length
      expect(subject).to eq(ave_rating)
    end
  end

  describe '#search_by_title' do
    it "returns an empty array if there are no videos in the db" do
      expect(Video.search_by_title('xxx')).to eq([])
    end

    it "returns an empty array if there are no matches" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      expect(Video.search_by_title('Family Guy')).to eq([])
    end

    it "returns an array with one element if there is one match" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      family_guy = Video.create(title: "Family Guy", description: "A cartoon.")

      expect(Video.search_by_title('Family Guy')).to eq([family_guy])
    end

    it "is case-insensitive" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      family_guy = Video.create(title: "Family Guy", description: "A cartoon.")

      expect(Video.search_by_title('family guy')).to eq([family_guy])
    end

    it "matches any part of the string -- one result" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      family_guy = Video.create(title: "Family Guy", description: "A cartoon.")

      expect(Video.search_by_title('family')).to eq([family_guy])
    end

    it "returns an array of all matches ordered by created_at (newest first)" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      family_guy_1 = Video.create(title: "Family Guy", description: "A cartoon.", created_at: 1.day.ago)
      family_guy_2 = Video.create(title: "Family Guy", description: "A cartoon.")

      results = Video.search_by_title('Family Guy')
      expect(results).to eq([family_guy_2, family_guy_1])
    end

    it "matches any part of the string -- multiple results" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      family_guy_1 = Video.create(title: "Family Guy", description: "A cartoon.", created_at: 1.day.ago)
      family_guy_2 = Video.create(title: "Family Guy", description: "A cartoon.")

      results = Video.search_by_title('amily')
      expect(results).to eq([family_guy_2, family_guy_1])
    end

    it "returns an empty array if the search string is empty or nil" do
      Video.create(title: "The Simpsons", description: "A cartoon.")
      Video.create(title: "Family Guy", description: "A cartoon.")

      expect(Video.search_by_title('')).to eq([])
      expect(Video.search_by_title(nil)).to eq([])
    end
  end
end
