# Requirements
require 'rails_helper'

feature 'Readit basic features' do
  scenario 'Anyone can visit root page and see a list of all the posts' do
    user = User.create!(email: "peter@cardi.com", password: "password")
    post1 = Post.create!(content: "Here is a great post", user_id: user.id)
    post2 = Post.create!(content: "Another fantastic piece of content!")
    visit root_path

    expect(page).to have_content("Readit Main Page")
    expect(page).to have_content("Here is a great post")
    expect(page).to have_content("Another fantastic piece of content!")
  end
end

# Anyone can visit the root page and see a list of all the posts
# Anyone can click on a post to view its comments
# Only a logged in user can submit a new post
# Only a logged in user can comment on a post
# Only the owner/creator of a post can edit that post
# Only the owner/creator of a post can delete that post
# Only the owner/creator of a comment can edit that comment
# Only the owner/creator of a comment can delete that comment
# The specific models, routing, and views are completely up to you.
#With that said, this assignment is meant to build on all the things you've been learning up to this point: authentication, nested routes, model associations, etc.
