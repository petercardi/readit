# Requirements
require 'rails_helper'

feature 'Readit basic features' do

  scenario 'Anyone can visit root page and see a list of all the posts' do

    user = User.create!(email: "peter@cardi.com", password: "password")
    post1 = Post.create!(title: "blah", post_content: "Here is a great post", user_id: user.id)
    post2 = Post.create!(title: "berries", post_content: "Another fantastic piece of content!", user_id: user.id)

    visit '/'

    expect(page).to have_content("Readit Main Page")
    expect(page).to have_link("berries")
    expect(page).to have_link("blah")
  end

  scenario 'Anyone can click on a post to view its comments' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!", user_id: user.id)
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

  scenario 'a logged in user can submit a new post' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    sign_in(user)
    visit root_path
    click_link "New Post"

    expect(page).to have_content("Add a New Post")
    fill_in :post_title, with: "Title of my new post"
    fill_in :post_post_content, with: "Content"
    within("form") { click_button "Create Post" }
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
    click_button "My 2 Cents' Worth"
    expect(current_path).to eq(post_path(post))
    expect(page).to have_content("Thanks for regaling us with your shitty opinions")
    expect(page).to have_content("Blaaaahhh balallhdlfjg")
  end

  scenario 'Only the owner/creator of a post can edit that post' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!", user_id: user.id)
    sign_in(user)
    visit post_path(post)
    click_on "Edit Post"
    fill_in :post_post_content, with: "Just kidding, this is what I really wanted to say"
    click_button "Update Post"
    expect(page).to have_content("Just kidding, this is what I really wanted to say")
    expect(page).to have_content("Updated that schitt")
  end

  scenario 'the owner/creator of a post can delete that post' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!", user_id: user.id)
    sign_in(user)
    visit post_path(post)
    click_on "Delete Post"

    expect { post.reload }.to raise_error ActiveRecord::RecordNotFound
    expect(current_path).to eq(posts_path)
    expect(page).to have_content("BURN IT ALL")
  end

  scenario "non-owners cannot delete posts" do
    user = User.create!(email: "peter@cardi.com", password: "password")
    user2 = User.create!(email: "jo@schmo.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!", user_id: user.id)
    sign_in(user2)

    visit post_path(post)
    expect(page).not_to have_content("Delete Post")
  end

  scenario 'Only the owner/creator of a comment can edit that comment' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post = Post.create!(title: "Shitty", post_content: "Another fantastic piece of content!", user_id: user.id)
    comment = Comment.create(content: "Here's a thing", post_id: post.id, user_id: user.id)
    sign_in(user)
    visit post_path(post)

    click_on "Edit Comment"
    fill_in :comment_content, with: "This is actually the comment I wanted to make"
    click_button "Update Comment"
    expect(page).to have_content("This is actually the comment I wanted to make")
  end
end
