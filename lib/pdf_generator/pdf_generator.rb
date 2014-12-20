module PdfGenerator
  class MyCrazyException < Exception
  end
  def git_pdf_responder
    pdf = Prawn::Document.new
    @logopath = "app/assets/images/logo_blue.jpg"
    #@user_image = "#{@user_info["items"][0]["profile_image"]}"
    pdf.image @logopath, :width => 197, :height => 120
    #pdf.image open (@user_image)
    pdf.fill_color "0066FF"
    pdf.font_size 42
    pdf.text_box "Knack Reports", :align => :right

    pdf.move_down 20
    pdf.font_size 14
    pdf.text "Below generated report for Github user #{@github_details['login']}"

    pdf.move_down 20

    #Retrieving a github details
    pdf.text "Login : #{@github_details['login']}"
    pdf.move_down 10
    pdf.text "Name : #{@github_details['name']}"
    pdf.move_down 10
    pdf.text "Email Id : #{@github_details['email']}"
    pdf.move_down 10
    pdf.text "Location : #{@github_details['location']}"
    pdf.move_down 10
    pdf.text "Login Id : #{@github_details['id']}"
    pdf.move_down 10
    pdf.text "Image Url : #{@github_details['avatar_url']}"
    pdf.move_down 10
    pdf.text "Company Name : #{@github_details['company']}"
    pdf.move_down 10
    pdf.text "User Site : #{@github_details['blog']}"
    pdf.move_down 10
    pdf.text "Github Account Url : #{@github_details['html_url']}"
    pdf.move_down 10
    pdf.text "Followers : #{@github_details['followers']}"
    pdf.move_down 10
    pdf.text "Following : #{@github_details['following']}"
    pdf.move_down 10
    pdf.text "Public Gists Count : #{@github_details['public_gists']}"
    pdf.move_down 10
    pdf.text "Public Repositories Count : #{@github_details['public_repos']}"
    pdf.move_down 10
    pdf.text "Hireable Status : #{@github_details['hireable']}"
    pdf.move_down 10
    pdf.text "Account Created On : #{@github_details['created_at']}"
    pdf.move_down 10
    pdf.text "Account Updated On : #{@github_details['updated_at']}"
    pdf.move_down 10

    #organizations work
    pdf.text "Organization List : #{@org_name_array}"
    pdf.move_down 10

    #detailed repo info
    pdf.text "Detailed Repo Info : #{@repo_req_info_array}"

    #graph generation using gruff bar for github
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Number of Public Gists & Public Repositories'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 5
    bar_graph.data('Number of Public Gists',["#{@github_details['public_gists']}".to_i])
    bar_graph.data('Number of Public Repositories',["#{@github_details['public_repos']}".to_i])
    bar_graph.write("public/gruff_graph/git_#{@github_details['login']}.png")
    @graph = "public/gruff_graph/git_#{@github_details['login']}.png"
    pdf.image @graph, :width => 550, :height => 690

    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def sof_pdf_responder
      pdf = Prawn::Document.new
      @logopath = "app/assets/images/logo_blue.jpg"
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

      #/users/{ids}
      pdf.text "User Id : #{@user_info["items"][0]["user_id"]}"
      pdf.move_down 10
      pdf.text "Display Name : #{@user_info["items"][0]["display_name"]}"
      pdf.move_down 10
      pdf.text "Location : #{@user_info["items"][0]["location"]}"
      pdf.move_down 10
      pdf.text "Last modified Date : #{@user_info["items"][0]["last_modified_date"]}"
      pdf.move_down 10
      pdf.text "Last Access Date : #{@user_info["items"][0]["last_access_date"]}"
      pdf.move_down 10
      pdf.text "Reputation Change In a Current Year : #{@user_info["items"][0]["reputation_change_year"]}"
      pdf.move_down 10
      pdf.text "Reputation Change In a Current Quarter : #{@user_info["items"][0]["reputation_change_quarter"]}"
      pdf.move_down 10
      pdf.text "Reputation Change In a Current Month : #{@user_info["items"][0]["reputation_change_month"]}"
      pdf.move_down 10
      pdf.text "Reputation Change In a Current Week : #{@user_info["items"][0]["reputation_change_week"]}"
      pdf.move_down 10
      pdf.text "Reputation Change In a Current Day : #{@user_info["items"][0]["reputation_change_day"]}"
      pdf.move_down 10
      pdf.text "Over All Reputation : #{@user_info["items"][0]["reputation"]}"
      pdf.move_down 10
      pdf.text "Personal Website Url : #{@user_info["items"][0]["website_url"]}"
      pdf.move_down 10
      pdf.text "SOF Link : #{@user_info["items"][0]["link"]}"
      pdf.move_down 10
      pdf.text "Image Link : #{@user_info["items"][0]["profile_image"]}"
      pdf.move_down 10
      pdf.text "User Gold Badge : #{@user_info["items"][0]["badge_counts"]["gold"]}"
      pdf.move_down 10
      pdf.text "User Silver Badge : #{@user_info["items"][0]["badge_counts"]["silver"]}"
      pdf.move_down 10
      pdf.text "User Bronze Badge : #{@user_info["items"][0]["badge_counts"]["bronze"]}"
      pdf.move_down 10

      #/users/{ids}/answers

      pdf.text "User Answer Count : #{@user_answer_count}"
      pdf.move_down 10
      pdf.text "Link to the answers : #{@answer_collect}"
      pdf.move_down 10

      #/users/{ids}/questions

      pdf.text "User Question Count : #{@user_question_count}"
      pdf.move_down 10
      pdf.text "Link to the questions : #{@question_collect}"
      pdf.move_down 10

      #/users/{id}/network-activity
      # have details about edit, post etc.. except accepted answer

      pdf.text "User Network Activity Count(Stack Exchange network, ex:stack overflow,Ask Ubuntu etc..) : #{@user_network_activity_count}"
      pdf.move_down 10

      #/users/{ids}/reputation-history

      pdf.text "User Reputation History : #{@user_reputation_array}"
      pdf.move_down 10

      #/users/{ids}/tags

      pdf.text "User Tags and Discussion Count : #{@user_tags_info_hash}"
      pdf.move_down 10

      #/users/{ids}/associated

      pdf.text "User Association and Reputation : #{@user_association_hash}"
      pdf.move_down 10

      #/users/{ids}/timeline

      pdf.text "User Actions in Stackoverflow(answered, commented, revision, accepted  etc..) : #{@user_timeline_count}"
      pdf.move_down 10

      #graph generation using gruff bar for reputation
      bar_graph = Gruff::Bar.new('550x690')
      bar_graph.title = 'Reputation graph'
      bar_graph.maximum_value = 50
      bar_graph.minimum_value = 0
      bar_graph.y_axis_increment = 10
      bar_graph.data('Reputation Change In a Current Year',["#{@user_info["items"][0]["reputation_change_year"]}".to_i])
      bar_graph.data('Reputation Change In a Current Quarter', ["#{@user_info["items"][0]["reputation_change_quarter"]}".to_i])
      bar_graph.data('Reputation Change In a Current Month',["#{@user_info["items"][0]["reputation_change_month"]}".to_i])
      bar_graph.data('Reputation Change In a Current Week',["#{@user_info["items"][0]["reputation_change_week"]}".to_i])
      bar_graph.data('Reputation Change In a Current Day',["#{@user_info["items"][0]["reputation_change_day"]}".to_i])
      bar_graph.data('Over All Reputation',["#{@user_info["items"][0]["reputation"]}".to_i])
      bar_graph.write("public/gruff_graph/sof_reputation_#{@user_info["items"][0]["user_id"]}.png")
      @graph = "public/gruff_graph/sof_reputation_#{@user_info["items"][0]["user_id"]}.png"
      pdf.image @graph, :width => 550, :height => 690

      #graph generation using gruff bar for User Reputation History
      bar_graph = Gruff::Bar.new('550x690')
      bar_graph.title = 'Reputation History graph'
      bar_graph.maximum_value = 10
      bar_graph.minimum_value = -10
      bar_graph.y_axis_increment = 2
      bar_graph.data('Reputation History',"#{@user_reputation_array}".split(",").map(&:to_i))
      bar_graph.write("public/gruff_graph/sof_reputation_history_#{@user_info["items"][0]["user_id"]}.png")
      @graph = "public/gruff_graph/sof_reputation_history_#{@user_info["items"][0]["user_id"]}.png"
      pdf.image @graph, :width => 550, :height => 690

      #graph generation using gruff bar for badge and qa
      bar_graph = Gruff::Bar.new('550x690')
      bar_graph.title = 'Badge & QA graph'
      bar_graph.maximum_value = 10
      bar_graph.minimum_value = 0
      bar_graph.y_axis_increment = 5
      bar_graph.data('User Gold Badge',["#{@user_info["items"][0]["badge_counts"]["gold"]}".to_i])
      bar_graph.data('User Silver Badge', ["#{@user_info["items"][0]["badge_counts"]["silver"]}".to_i])
      bar_graph.data('User Bronze Badge',["#{@user_info["items"][0]["badge_counts"]["bronze"]}".to_i])
      bar_graph.data('User Answer Count',["#{@user_answer_count}".to_i])
      bar_graph.data('User Question Count',["#{@user_question_count}".to_i])
      bar_graph.write("public/gruff_graph/sof_badge_qa_#{@user_info["items"][0]["user_id"]}.png")
      @graph = "public/gruff_graph/sof_badge_qa_#{@user_info["items"][0]["user_id"]}.png"
      pdf.image @graph, :width => 550, :height => 690
      send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def blog_pdf_responder
      pdf = Prawn::Document.new
      @logopath = "app/assets/images/logo_blue.jpg"
      #@user_image = "#{@user_info["items"][0]["profile_image"]}"
      pdf.image @logopath, :width => 197, :height => 120
      #pdf.image open (@user_image)
      pdf.fill_color "0066FF"
      pdf.font_size 42
      pdf.text_box "Knack Reports", :align => :right
      pdf.font_size 14
      item = [
              "Below generated report for Google Blogger user #{@blog_details['name']}",

              #Retrieving a blog
              "Blog Id : #{@blog_details['id']}", "Blog Name : #{@blog_details['name']}",
              "Blog Url : #{@blog_details['url']}",
              "Number of Posts : #{@blog_details['posts']['totalItems']}",
              "Number of Pages : #{@blog_details['pages']['totalItems']}",
              "Language : #{@blog_details['locale']['language']}"
             ]
      item.each {|i| pdf.text "#{i}"
                 pdf.move_down 10}

      #Retrieving posts from a blog
      if !@post_comm_hash.nil?
        pdf.text "Title and Comments(last 10 blogs)"
        pdf.move_down 10
        @post_comm_hash.each do |k,v| pdf.text "#{k} : #{v.join('')}"
                                      pdf.move_down 10
        end
      end

      #Retrieving pages for a blog
      if !@page_array.nil?
        pdf.text "Pages"
        pdf.move_down 10
        @page_array.each {|i| pdf.text "#{i}"
        pdf.move_down 10}
      end

      #graph generation using gruff bar for blog count
      bar_graph = Gruff::Bar.new('550x690')
      graph_item = ['title : Number of posts & pages graph',
                    'maximum_value : 10', 'minimum_value : 0',
                    'y_axis_increment : 5',
                    "data('Number of posts',[\"#{@blog_details['posts']['totalItems']}\".to_i] ",
                    "data('Number of pages',[\"#{@blog_details['pages']['totalItems']}\".to_i]) ",
                    "write(\"public/gruff_graph/num_posts_pages_#{@blog_details['id']}.png\")] "]
      graph_item.each {
          |i|   "bar_graph.#{i}"
      }
      @graph = "public/gruff_graph/num_posts_pages_#{@blog_details['id']}.png"
      pdf.image @graph, :width => 550, :height => 690
      send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

end