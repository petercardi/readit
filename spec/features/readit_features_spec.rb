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

  scenario 'Only a logged in user can submit a new post' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    sign_in(user)
    visit root_path
    click_link "New Post"

    expect(page).to have_content("Add a New Post")
    fill_in :post_title, with: "Title of my new post"
    fill_in :post_post_content, with: "Content"
    within("form") { click_button "CREATE DAT POST" }
    expect(page).to have_content("Title of my new post")
    expect(current_path).to eq(posts_path)
  end

  scenario 'Non-logged in user cannot submit a new post' do
    visit root_path
    expect(page).to_not have_link("New Post")
  end

  scenario 'Only a logged in user can comment on a post' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!")
    sign_in(user)
    visit post_path(post)

    fill_in :comment_content, with: "Blaaaahhh balallhdlfjg"
    click_link "My 2 Cents' Worth"
    expect(current_path).to eq(post_path(post))
    expect(page).to have_content("Thanks for regaling us with your shitty opinions")
    expect(page).to have_content("Blaaaahhh balallhdlfjg")
  end
end

# Only a logged in user can comment on a post
# Only the owner/creator of a post can edit that post
# Only the owner/creator of a post can delete that post
# Only the owner/creator of a comment can edit that comment
# Only the owner/creator of a comment can delete that comment
# The specific models, routing, and views are completely up to you.
#With that said, this assignment is meant to build on all the things you've been learning up to this point: authentication, nested routes, model associations, etc.
