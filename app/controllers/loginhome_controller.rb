#require 'open-uri'
class LoginhomeController < ApplicationController

  include HTTParty
  #base_uri "http://api.stackexchange.com/2.2"
  def getoption

  end

  def sof_consumer
    @user_id = request["user_id"]

    #/users/{ids}
    @user_info = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}?order=desc&sort=reputation&site=stackoverflow")

    #/users/{ids}/answers
    @user_answer = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/answers?order=desc&sort=activity&site=stackoverflow")
    @user_answer_count = @user_answer["items"].count
    @answer_collect = Array.new()
    if @user_answer["items"] != nil
    @user_answer["items"].each { |item| @answer_collect << "http://stackoverflow.com/q/#{item["answer_id"]}"}
    else
      @user_answer["items"] = nil
    end

    #/users/{ids}/questions
    @user_question = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/questions?order=desc&sort=activity&site=stackoverflow")
    @user_question_count = @user_question["items"].count
    @question_collect = Array.new()
    if @user_question["items"] != nil
      @user_question["items"].each { |item| @question_collect << "http://stackoverflow.com/q/#{item["question_id"]}"}
    else
      @user_question["items"] = nil
    end

    #/users/{id}/network-activity
    @user_network_activity = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_info["items"][0]["account_id"]}/network-activity")
    @user_network_activity_count = @user_network_activity["items"].count

    #/users/{ids}/reputation-history
    @user_reputation_history = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/reputation-history?site=stackoverflow")
    @user_reputation_array = Array.new()
    if @user_reputation_history["items"] != nil
      @user_reputation_history["items"].each { |repu| @user_reputation_array << repu["reputation_change"] }
    else
      @user_reputation_history["items"] = nil
    end

    #/users/{ids}/tags
    @user_tags = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/tags?order=desc&sort=popular&site=stackoverflow")
    @user_tags_info_hash = Hash.new()
    if @user_tags["items"] != nil
      @user_tags["items"].each { |tag| @user_tags_info_hash["#{tag["name"]}"] = tag["count"]}
    else
      @user_tags["items"] = nil
    end

    #/users/{ids}/associated
    @user_association = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_info["items"][0]["account_id"]}/associated")
    @user_association_hash = Hash.new()
    if @user_association["items"] != nil
      @user_association["items"].each { |asso| @user_association_hash["#{asso["site_name"]}"] = asso["reputation"] }
    else
      @user_association["items"] = nil
    end

    #/users/{ids}/timeline
    @user_timeline = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/timeline?site=stackoverflow")
    @user_timeline_count = @user_timeline["items"].count

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        @logopath = "public/pie-chart-1.png"
        #@user_image = "#{@user_info["items"][0]["profile_image"]}"
        pdf.image @logopath, :width => 197, :height => 120
        #pdf.image open (@user_image)
        pdf.fill_color "0066FF"
        pdf.font_size 42
        pdf.text_box "Knack Reports", :align => :right

        pdf.move_down 20
        pdf.font_size 14
        pdf.text "Below generated report for stack overflow user #{@user_info["items"][0]["display_name"]}"

        pdf.move_down 20
        to_show = [
                   #/users/{ids}

                   ["User Id", "#{@user_info["items"][0]["user_id"]}"],
                   ["Display Name", "#{@user_info["items"][0]["display_name"]}"],
                   ["Location", "#{@user_info["items"][0]["location"]}"],
                   ["Last modified Date", "#{@user_info["items"][0]["last_modified_date"]}"],
                   ["Last Access Date", "#{@user_info["items"][0]["last_access_date"]}"],
                   ["Reputation Change In a Current Year", "#{@user_info["items"][0]["reputation_change_year"]}"],
                   ["Reputation Change In a Current Quarter", "#{@user_info["items"][0]["reputation_change_quarter"]}"],
                   ["Reputation Change In a Current Month", "#{@user_info["items"][0]["reputation_change_month"]}"],
                   ["Reputation Change In a Current Week", "#{@user_info["items"][0]["reputation_change_week"]}"],
                   ["Reputation Change In a Current Day", "#{@user_info["items"][0]["reputation_change_day"]}"],
                   ["Over All Reputation", "#{@user_info["items"][0]["reputation"]}"],
                   ["Personal Website Url", "#{@user_info["items"][0]["website_url"]}"],
                   ["SOF Link", "#{@user_info["items"][0]["link"]}"],
                   ["Image Link", "#{@user_info["items"][0]["profile_image"]}"],
                   ["User Gold Badge", "#{@user_info["items"][0]["badge_counts"]["gold"]}"],
                   ["User Silver Badge", "#{@user_info["items"][0]["badge_counts"]["silver"]}"],
                   ["User Bronze Badge", "#{@user_info["items"][0]["badge_counts"]["bronze"]}"],

                   #/users/{ids}/answers

                   ["User Answer Count", "#{@user_answer_count}"],    
                   ["Link to the answers", "#{@answer_collect}"],

                   #/users/{ids}/questions

                   ["User Question Count", "#{@user_question_count}"],
                   ["Link to the questions", "#{@question_collect}"],

                   #/users/{id}/network-activity
                   # have details about edit, post etc.. except accepted answer
                   ["User Network Activity Count(Stack Exchange network, ex:stack overflow,Ask Ubuntu etc..)", "#{@user_network_activity_count}"],

                   #/users/{ids}/reputation-history

                   ["User Reputation History", "#{@user_reputation_array}"],

                   #/users/{ids}/tags

                   ["User Tags and Discussion Count", "#{@user_tags_info_hash}"],

                   #/users/{ids}/associated

                   ["User Association and Reputation", "#{@user_association_hash}"],

                   #/users/{ids}/timeline

                   ["User Actions in Stackoverflow(answered, commented, revision, accepted  etc..)", "#{@user_timeline_count}"]

        ]
        pdf.table(to_show) do |table|
          table.rows(1..2).width = 270
        end
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end

  end

  def git_consumer
    @name = request["gitname"]
    @hash_values=Github.repos.list user: "#{@name}", repo:'-Contactform'
    puts '============================'
    puts     @hash_values.length
    puts '============================'
  end

  def blog_consumer
    @blogger_id = request["bloggerid"]

    #Retrieving a blog
    @blog_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")

    #Retrieving posts from a blog
    @post_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}/posts?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")
    @post_comm_hash = Hash.new()

    if @post_details['items'] != nil
      @post_details['items'].each { |obj| @post_comm_hash["#{obj['title']}"] = ["#{obj['replies']['totalItems']}"] }
    else
      @post_comm_hash = nil
    end

    #Retrieving pages for a blog
    @page_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}/pages?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")
    @page_array = Array.new()
    if @page_details['items'] != nil
      @page_details['items'].each { |obj| @page_array << obj['title'] }
    else
      @page_array = nil
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        @logopath = "public/pie-chart-1.png"
        #@user_image = "#{@user_info["items"][0]["profile_image"]}"
        pdf.image @logopath, :width => 197, :height => 120
        #pdf.image open (@user_image)
        pdf.fill_color "0066FF"
        pdf.font_size 42
        pdf.text_box "Knack Reports", :align => :right

        pdf.move_down 20
        pdf.font_size 14
        #pdf.text "Below generated report for Google Blogger user #{@user_info["items"][0]["display_name"]}"

        pdf.move_down 20
        to_show = [
            #Retrieving a blog
            ["Blog Id", "#{@blog_details['id']}"],
            ["Blog Name", "#{@blog_details['name']}"],
            ["Blog Url", "#{@blog_details['url']}"],
            ["Number of Posts", "#{@blog_details['posts']['totalItems']}"],
            ["Number of Pages", "#{@blog_details['pages']['totalItems']}"],
            ["Language", "#{@blog_details['locale']['language']}"] ,

           #Retrieving posts from a blog
           ["Title and Comments(last 10 blogs)", "#{@post_comm_hash}"],

           #Retrieving pages for a blog
           ["Pages", "#{@page_array}"]
        ]
        pdf.table(to_show) do |table|
          table.rows(1..2).width = 270
        end
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end

  end

  def bit_b_consumer
    @name = request["name"]
    puts '++++++++++'
    puts @name
    puts '++++++++++'
    response = HTTParty.get("https://bitbucket.org/api/1.0/users/#{@name}")
    puts '-----------------'
    puts response.body
    puts '-----------------'
  end

  def cloud_forge_consumer

  end

  def linked_in_consumer

  end


end
