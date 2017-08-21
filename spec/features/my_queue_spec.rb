require 'spec_helper'

feature "my_queue" do
  given(:password) { 'test' }
  given(:user) { Fabricate(:user, password: password) }
  # given(:video1) { Fabricate(:video) }
  # given(:video2) { Fabricate(:video) }
  # given(:video3) { Fabricate(:video) }

  # background do
  #   video1
  #   video2
  #   video3
  # end

  scenario "complicated flow" do
    category = Fabricate(:category)
    video1 = Fabricate(:video, category: category)
    video2 = Fabricate(:video, category: category)
    video3 = Fabricate(:video, category: category)

    sign_in_user(user, password)

    add_video_to_queue(video1)
    expect(page).to have_current_path(my_queue_path)
    expect(page).to have_content(video1.title)

    click_link(video1.title)
    expect(page).to have_current_path(video_path(video1))
    expect(page).not_to have_button("+ My Queue")

    add_video_to_queue(video2)
    add_video_to_queue(video3)

    expect(page).to have_content(video1.title)
    expect(page).to have_content(video2.title)
    expect(page).to have_content(video3.title)

    set_video_position(video1, 2)
    set_video_position(video2, 3)
    set_video_position(video3, 1)

    click_button("Update Instant Queue")

    expect_video_position(video1, 2)
    expect_video_position(video2, 3)
    expect_video_position(video3, 1)
  end

  def add_video_to_queue(video)
    visit home_path
    # click_link("Videos")
    click_link(href: video_path(video))
    click_button("+ My Queue")
  end

  def set_video_position(video, position)
    # See your notes for diff't ways of doing this.
    q = QueuedUserVideo.find_by video: video, user: user
    fill_in("new_positions_#{q.id}", with: position)
  end

  def expect_video_position(video, position)
    q = QueuedUserVideo.find_by video: video, user: user
    expect(page.find_field("new_positions_#{q.id}").value).to eq(position.to_s)
  end
end
