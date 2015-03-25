# Requirements
require 'rails_helper'

feature 'Readit basic features' do
  scenario 'Anyone can visit root page and see a list of all the posts' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post1 = Post.create!(title: "blah", post_content: "Here is a great post", user_id: user.id)
    post2 = Post.create!(title: "berries", post_content: "Another fantastic piece of content!")

    visit root_path
    expect(page).to have_content("Readit Main Page")
    expect(page).to have_link("berries")
    expect(page).to have_link("blah")
  end

  scenario 'Anyone can click on a post to view its comments' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!")
    Comment.create!(post_id: post.id, user_id: user.id, content: "Great comment from internetz")
    Comment.create!(post_id: post.id, user_id: user.id, content: "I <3 cats")

    visit root_path
    click_link "Shitty"

    expect(current_path).to eq(post_path(post))
    expect(page).to have_content("Shitty")
    expect(page).to have_content("Another fantastic piece of content!")
    expect(page).to have_content("Great comment from internetz")
    expect(page).to have_content("I <3 cats")
  end
end




# Anyone can click on a post to view its comments
# Only a logged in user can submit a new post
# Only a logged in user can comment on a post
# Only the owner/creator of a post can edit that post
# Only the owner/creator of a post can delete that post
# Only the owner/creator of a comment can edit that comment
# Only the owner/creator of a comment can delete that comment
# The specific models, routing, and views are completely up to you.
#With that said, this assignment is meant to build on all the things you've been learning up to this point: authentication, nested routes, model associations, etc.
