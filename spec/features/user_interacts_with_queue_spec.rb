require 'spec_helper'

feature "User interacts with queue" do
    scenario "user adds and reorders videos in the queue" do
        comedies = Fabricate(:category)
        south_park = Fabricate(:video, title: "South Park", category: comedies)
        family_guy = Fabricate(:video, title: "Family Guy", category: comedies)
        futurama = Fabricate(:video, title: "Futurama", category: comedies)

        sign_in

        add_video_to_queue(south_park)
        expect_video_to_be_in_queue(south_park)

        visit video_path(south_park)
        expect_link_not_to_be_visible("+ My Queue")

        add_video_to_queue(family_guy)
        add_video_to_queue(futurama)

        set_video_position(south_park, 3)
        set_video_position(family_guy, 2)
        set_video_position(futurama, 1)
        update_queue

        expect_video_position(south_park,3)    
        expect_video_position(family_guy,2)    
        expect_video_position(futurama,1)    
    end

    def expect_video_to_be_in_queue(video)
        page.should have_content(video.title)
    end

    def expect_link_not_to_be_visible(link_text)
        page.should_not have_content(link_text)
    end

    def update_queue
        click_button "Update Instant Queue"
    end

    def add_video_to_queue(video)
        visit home_path
        find("a[href='/videos/#{video.id}']").click
        click_link "+ My Queue"
    end

    def set_video_position(video, position)
        within(:xpath, "//tr[contains(.,'#{video.title}')]") do
            fill_in "queue_items[][position]", with: position.to_s
        end
    end

    def expect_video_position(video, position)
        expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)    
    end
end