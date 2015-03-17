module PdfGenerator

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

    item = ["Below generated report for Github user #{@github_details['login']}",

            #Retrieving a github details
            "Login : #{@github_details['login']}", "Name : #{@github_details['name']}",
            "Email Id : #{@github_details['email']}", "Location : #{@github_details['location']}",
            "Login Id : #{@github_details['id']}", "Image Url : #{@github_details['avatar_url']}",
            "Company Name : #{@github_details['company']}", "User Site : #{@github_details['blog']}",
            "Github Account Url : #{@github_details['html_url']}", "Followers : #{@github_details['followers']}",
            "Following : #{@github_details['following']}", "Public Gists Count : #{@github_details['public_gists']}",
            "Public Repositories Count : #{@github_details['public_repos']}", "Hireable Status : #{@github_details['hireable']}",
            "Account Created On : #{@github_details['created_at']}", "Account Updated On : #{@github_details['updated_at']}",

            #organizations work
            "Organization List : #{@org_name_array}"]

    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #detailed repo info
    if !@repo_req_info_array.nil?
      pdf.text "Detailed Repo Info"
      pdf.move_down 10
      @repo_req_info_array.each { |i| pdf.text "#{i}"
      pdf.move_down 10 }
    end

    #graph generation using gruff bar for github
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Number of Public Gists & Public Repositories'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 5
    bar_graph.data('Number of Public Gists',["#{@github_details['public_gists']}".to_i])
    bar_graph.data('Number of Public Repositories',["#{@github_details['public_repos']}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/git_#{@github_details['login']}_#{Time.now}.png")
    @graph = "#{image_url}"
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
    pdf.font_size 14
    item = ["Below generated report for stack overflow user #{@user_info["items"][0]["display_name"]}",

            #/users/{ids}
            "User Id : #{@user_info["items"][0]["user_id"]}",
            "Display Name : #{@user_info["items"][0]["display_name"]}",
            "Location : #{@user_info["items"][0]["location"]}",
            "Last modified Date : #{@user_info["items"][0]["last_modified_date"]}",
            "Last Access Date : #{@user_info["items"][0]["last_access_date"]}",
            "Reputation Change In a Current Year : #{@user_info["items"][0]["reputation_change_year"]}",
            "Reputation Change In a Current Quarter : #{@user_info["items"][0]["reputation_change_quarter"]}",
            "Reputation Change In a Current Month : #{@user_info["items"][0]["reputation_change_month"]}",
            "Reputation Change In a Current Week : #{@user_info["items"][0]["reputation_change_week"]}",
            "Reputation Change In a Current Day : #{@user_info["items"][0]["reputation_change_day"]}",
            "Over All Reputation : #{@user_info["items"][0]["reputation"]}",
            "Personal Website Url : #{@user_info["items"][0]["website_url"]}",
            "SOF Link : #{@user_info["items"][0]["link"]}",
            "Image Link : #{@user_info["items"][0]["profile_image"]}",
            "User Gold Badge : #{@user_info["items"][0]["badge_counts"]["gold"]}",
            "User Silver Badge : #{@user_info["items"][0]["badge_counts"]["silver"]}",
            "User Bronze Badge : #{@user_info["items"][0]["badge_counts"]["bronze"]}",

            #/users/{ids}/answers
            #"User Answer Count : #{@user_answer_count}",
            "Link to the answers(last 30) : #{@answer_collect}",

            #/users/{ids}/questions
            #"User Question Count : #{@user_question_count}",
            "Link to the questions(last 30) : #{@question_collect}",

            #/users/{id}/network-activity
            # have details about edit, post etc.. except accepted answer
            #"User Network Activity Count(Stack Exchange network, ex:stack overflow,Ask Ubuntu etc..) : #{@user_network_activity_count}",

            #/users/{ids}/reputation-history
            "User Reputation History(last 30) : #{@user_reputation_array}",

            #/users/{ids}/timeline
            #"User Actions in Stackoverflow(answered, commented, revision, accepted  etc..) : #{@user_timeline_count}"

    ]
    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #/users/{ids}/tags
    if !@user_tags_info_hash.nil?
      pdf.text "User Tags and Discussion Count"
      pdf.move_down 10
      @user_tags_info_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #/users/{ids}/associated
    if !@user_association_hash.nil?
      pdf.text "User Association and Reputation"
      pdf.move_down 10
      @user_association_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #graph generation using gruff bar for reputation
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation graph'
    bar_graph.maximum_value = 50000
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 10000
    bar_graph.data('Reputation Change In a Current Year',["#{@user_info["items"][0]["reputation_change_year"]}".to_i])
    bar_graph.data('Reputation Change In a Current Quarter', ["#{@user_info["items"][0]["reputation_change_quarter"]}".to_i])
    bar_graph.data('Reputation Change In a Current Month',["#{@user_info["items"][0]["reputation_change_month"]}".to_i])
    bar_graph.data('Reputation Change In a Current Week',["#{@user_info["items"][0]["reputation_change_week"]}".to_i])
    bar_graph.data('Reputation Change In a Current Day',["#{@user_info["items"][0]["reputation_change_day"]}".to_i])
    bar_graph.data('Over All Reputation',["#{@user_info["items"][0]["reputation"]}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for User Reputation History
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation History graph'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = -10
    bar_graph.y_axis_increment = 2
    bar_graph.data('Reputation History',"#{@user_reputation_array}".split(",").map(&:to_i))
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_history_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for badge and qa
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Badge graph'#& QA graph'
    bar_graph.maximum_value = 500
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 20
    bar_graph.data('User Gold Badge',["#{@user_info["items"][0]["badge_counts"]["gold"]}".to_i])
    bar_graph.data('User Silver Badge', ["#{@user_info["items"][0]["badge_counts"]["silver"]}".to_i])
    bar_graph.data('User Bronze Badge',["#{@user_info["items"][0]["badge_counts"]["bronze"]}".to_i])
    #bar_graph.data('User Answer Count',["#{@user_answer_count}".to_i])
    #bar_graph.data('User Question Count',["#{@user_question_count}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/sof_badge_qa_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
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
    item = ["Below generated report for Google Blogger user #{@blog_details['name']}",

            #Retrieving a blog
            "Blog Id : #{@blog_details['id']}", "Blog Name : #{@blog_details['name']}",
            "Blog Url : #{@blog_details['url']}",
            "Number of Posts : #{@blog_details['posts']['totalItems']}",
            "Number of Pages : #{@blog_details['pages']['totalItems']}",
            "Language : #{@blog_details['locale']['language']}"
    ]
    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #Retrieving posts from a blog
    if !@post_comm_hash.nil?
      pdf.text "Title and Comments(last 10 blogs)"
      pdf.move_down 10
      @post_comm_hash.each do |k, v|
        pdf.text "#{k} : #{v.join('')}"
        pdf.move_down 10
      end
    end

    #Retrieving pages for a blog
    if !@page_array.nil?
      pdf.text "Pages"
      pdf.move_down 10
      @page_array.each { |i| pdf.text "#{i}"
      pdf.move_down 10 }
    end

    #graph generation using gruff bar for blog count
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Number of posts & pages graph'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 5
    bar_graph.data('Number of posts',["#{@blog_details['posts']['totalItems']}".to_i])
    bar_graph.data('Number of pages',["#{@blog_details['pages']['totalItems']}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/blog_num_posts_pages_#{@blog_details['id']}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690
    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def lin_pdf_responder
    pdf = Prawn::Document.new
    @logopath = "app/assets/images/logo_blue.jpg"
    pdf.image @logopath, :width => 197, :height => 120
    pdf.fill_color "0066FF"
    pdf.font_size 22
    pdf.text_box "Knack Reports", :align => :right
    pdf.font_size 14
    pdf.text "Below generated report for Linkedin user #{@pro_info_hash['Name']}"
    pdf.move_down 20
    if !@pro_info_hash.nil?
      @pro_info_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end
    if !@pro_info_hash_array.nil?
      @pro_info_hash_array.each do |k, v|
        pdf.text "#{k.to_s} : "
        v.each { |k1, v1|  k1.each {|k2, v2|pdf.text "#{k2} : #{v2}"}}
        pdf.move_down 10
      end
    end

    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def bit_b_pdf_responder
    pdf = Prawn::Document.new
    @logopath = "app/assets/images/logo_blue.jpg"
    pdf.image @logopath, :width => 197, :height => 120
    pdf.fill_color "0066FF"
    pdf.font_size 42
    pdf.text_box "Knack Reports", :align => :right
    pdf.font_size 14
    item = ["Below generated report for Bitbucket user #{@bit_b_user_details['username']}",

            #Retrieving a user info
            "Display Name : #{@bit_b_user_details['display_name']}",
            "Project page URL : #{@bit_b_user_details['links']['html']['href']}",
            "Avatar URL : #{@bit_b_user_details['links']['avatar']['href']}",

            #retriving user followers
            "Followers(up to 100) : #{@bit_b_u_f_a}",

            #retriving user following
            "Following(up to 100) : #{@bit_b_u_fg_a}"

            ]
    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #detailed repo info
    if !@bit_b_user_repo_info_array.nil?
      pdf.text "Detailed Repo Info"
      pdf.move_down 10
      @bit_b_user_repo_info_array.each { |i| pdf.text "#{i}"
      pdf.move_down 10 }
    end

    #graph generation using gruff bar for bitbucket
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Number of projects & followers graph'
    bar_graph.maximum_value = 50
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 10
    bar_graph.data('Number of projects',["#{@bit_b_repo_count}".to_i])
    bar_graph.data('Number of followers',["#{@bit_b_u_f_a}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/bit_b_graph_#{@bit_b_name}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690
    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def prog_pdf_responder
    pdf = Prawn::Document.new
    @logopath = "app/assets/images/logo_blue.jpg"
    #@user_image = "#{@user_info["items"][0]["profile_image"]}"
    pdf.image @logopath, :width => 197, :height => 120
    #pdf.image open (@user_image)
    pdf.fill_color "0066FF"
    pdf.font_size 42
    pdf.text_box "Knack Reports", :align => :right
    pdf.font_size 14
    item = ["Below generated report for programmers user #{@user_info["items"][0]["display_name"]}",

            #/users/{ids}
            "User Id : #{@user_info["items"][0]["user_id"]}",
            "Display Name : #{@user_info["items"][0]["display_name"]}",
            "Location : #{@user_info["items"][0]["location"]}",
            "Last modified Date : #{@user_info["items"][0]["last_modified_date"]}",
            "Last Access Date : #{@user_info["items"][0]["last_access_date"]}",
            "Reputation Change In a Current Year : #{@user_info["items"][0]["reputation_change_year"]}",
            "Reputation Change In a Current Quarter : #{@user_info["items"][0]["reputation_change_quarter"]}",
            "Reputation Change In a Current Month : #{@user_info["items"][0]["reputation_change_month"]}",
            "Reputation Change In a Current Week : #{@user_info["items"][0]["reputation_change_week"]}",
            "Reputation Change In a Current Day : #{@user_info["items"][0]["reputation_change_day"]}",
            "Over All Reputation : #{@user_info["items"][0]["reputation"]}",
            "Personal Website Url : #{@user_info["items"][0]["website_url"]}",
            "Programmers Link : #{@user_info["items"][0]["link"]}",
            "Image Link : #{@user_info["items"][0]["profile_image"]}",
            "User Gold Badge : #{@user_info["items"][0]["badge_counts"]["gold"]}",
            "User Silver Badge : #{@user_info["items"][0]["badge_counts"]["silver"]}",
            "User Bronze Badge : #{@user_info["items"][0]["badge_counts"]["bronze"]}",

            #/users/{ids}/answers
            #"User Answer Count : #{@user_answer_count}",
            "Link to the answers(last 30) : #{@answer_collect}",

            #/users/{ids}/questions
            #"User Question Count : #{@user_question_count}",
            "Link to the questions(last 30) : #{@question_collect}",

            #/users/{id}/network-activity
            # have details about edit, post etc.. except accepted answer
            #"User Network Activity Count(Stack Exchange network, ex:stack overflow,Ask Ubuntu etc..) : #{@user_network_activity_count}",

            #/users/{ids}/reputation-history
            "User Reputation History(last 30) : #{@user_reputation_array}",

            #/users/{ids}/timeline
            #"User Actions in Programmers(answered, commented, revision, accepted  etc..) : #{@user_timeline_count}"

    ]
    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #/users/{ids}/tags
    if !@user_tags_info_hash.nil?
      pdf.text "User Tags and Discussion Count"
      pdf.move_down 10
      @user_tags_info_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #/users/{ids}/associated
    if !@user_association_hash.nil?
      pdf.text "User Association and Reputation"
      pdf.move_down 10
      @user_association_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #graph generation using gruff bar for reputation
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation graph'
    bar_graph.maximum_value = 50000
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 10000
    bar_graph.data('Reputation Change In a Current Year',["#{@user_info["items"][0]["reputation_change_year"]}".to_i])
    bar_graph.data('Reputation Change In a Current Quarter', ["#{@user_info["items"][0]["reputation_change_quarter"]}".to_i])
    bar_graph.data('Reputation Change In a Current Month',["#{@user_info["items"][0]["reputation_change_month"]}".to_i])
    bar_graph.data('Reputation Change In a Current Week',["#{@user_info["items"][0]["reputation_change_week"]}".to_i])
    bar_graph.data('Reputation Change In a Current Day',["#{@user_info["items"][0]["reputation_change_day"]}".to_i])
    bar_graph.data('Over All Reputation',["#{@user_info["items"][0]["reputation"]}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for User Reputation History
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation History graph'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = -10
    bar_graph.y_axis_increment = 2
    bar_graph.data('Reputation History',"#{@user_reputation_array}".split(",").map(&:to_i))
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_history_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for badge and qa
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Badge graph'#& QA graph'
    bar_graph.maximum_value = 500
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 20
    bar_graph.data('User Gold Badge',["#{@user_info["items"][0]["badge_counts"]["gold"]}".to_i])
    bar_graph.data('User Silver Badge', ["#{@user_info["items"][0]["badge_counts"]["silver"]}".to_i])
    bar_graph.data('User Bronze Badge',["#{@user_info["items"][0]["badge_counts"]["bronze"]}".to_i])
    #bar_graph.data('User Answer Count',["#{@user_answer_count}".to_i])
    #bar_graph.data('User Question Count',["#{@user_question_count}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/prog_badge_qa_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690
    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end

  def elu_pdf_responder
    pdf = Prawn::Document.new
    @logopath = "app/assets/images/logo_blue.jpg"
    #@user_image = "#{@user_info["items"][0]["profile_image"]}"
    pdf.image @logopath, :width => 197, :height => 120
    #pdf.image open (@user_image)
    pdf.fill_color "0066FF"
    pdf.font_size 42
    pdf.text_box "Knack Reports", :align => :right
    pdf.font_size 14
    item = ["Below generated report for English Language & Usage user #{@user_info["items"][0]["display_name"]}",

            #/users/{ids}
            "User Id : #{@user_info["items"][0]["user_id"]}",
            "Display Name : #{@user_info["items"][0]["display_name"]}",
            "Location : #{@user_info["items"][0]["location"]}",
            "Last modified Date : #{@user_info["items"][0]["last_modified_date"]}",
            "Last Access Date : #{@user_info["items"][0]["last_access_date"]}",
            "Reputation Change In a Current Year : #{@user_info["items"][0]["reputation_change_year"]}",
            "Reputation Change In a Current Quarter : #{@user_info["items"][0]["reputation_change_quarter"]}",
            "Reputation Change In a Current Month : #{@user_info["items"][0]["reputation_change_month"]}",
            "Reputation Change In a Current Week : #{@user_info["items"][0]["reputation_change_week"]}",
            "Reputation Change In a Current Day : #{@user_info["items"][0]["reputation_change_day"]}",
            "Over All Reputation : #{@user_info["items"][0]["reputation"]}",
            "Personal Website Url : #{@user_info["items"][0]["website_url"]}",
            "SOF Link : #{@user_info["items"][0]["link"]}",
            "Image Link : #{@user_info["items"][0]["profile_image"]}",
            "User Gold Badge : #{@user_info["items"][0]["badge_counts"]["gold"]}",
            "User Silver Badge : #{@user_info["items"][0]["badge_counts"]["silver"]}",
            "User Bronze Badge : #{@user_info["items"][0]["badge_counts"]["bronze"]}",

            #/users/{ids}/answers
            #"User Answer Count : #{@user_answer_count}",
            "Link to the answers(last 30) : #{@answer_collect}",

            #/users/{ids}/questions
            #"User Question Count : #{@user_question_count}",
            "Link to the questions(last 30) : #{@question_collect}",

            #/users/{id}/network-activity
            # have details about edit, post etc.. except accepted answer
            #"User Network Activity Count(Stack Exchange network, ex:stack overflow,Ask Ubuntu etc..) : #{@user_network_activity_count}",

            #/users/{ids}/reputation-history
            "User Reputation History(last 30) : #{@user_reputation_array}",

    #/users/{ids}/timeline
    #"User Actions in Stackoverflow(answered, commented, revision, accepted  etc..) : #{@user_timeline_count}"

    ]
    item.each { |i| pdf.text "#{i}"
    pdf.move_down 10 }

    #/users/{ids}/tags
    if !@user_tags_info_hash.nil?
      pdf.text "User Tags and Discussion Count"
      pdf.move_down 10
      @user_tags_info_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #/users/{ids}/associated
    if !@user_association_hash.nil?
      pdf.text "User Association and Reputation"
      pdf.move_down 10
      @user_association_hash.each do |k, v|
        pdf.text "#{k} : #{v}"
        pdf.move_down 10
      end
    end

    #graph generation using gruff bar for reputation
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation graph'
    bar_graph.maximum_value = 50000
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 10000
    bar_graph.data('Reputation Change In a Current Year',["#{@user_info["items"][0]["reputation_change_year"]}".to_i])
    bar_graph.data('Reputation Change In a Current Quarter', ["#{@user_info["items"][0]["reputation_change_quarter"]}".to_i])
    bar_graph.data('Reputation Change In a Current Month',["#{@user_info["items"][0]["reputation_change_month"]}".to_i])
    bar_graph.data('Reputation Change In a Current Week',["#{@user_info["items"][0]["reputation_change_week"]}".to_i])
    bar_graph.data('Reputation Change In a Current Day',["#{@user_info["items"][0]["reputation_change_day"]}".to_i])
    bar_graph.data('Over All Reputation',["#{@user_info["items"][0]["reputation"]}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for User Reputation History
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Reputation History graph'
    bar_graph.maximum_value = 10
    bar_graph.minimum_value = -10
    bar_graph.y_axis_increment = 2
    bar_graph.data('Reputation History',"#{@user_reputation_array}".split(",").map(&:to_i))
    bar_graph.write(image_url = "public/gruff_graph/sof_reputation_history_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690

    #graph generation using gruff bar for badge and qa
    bar_graph = Gruff::Bar.new('550x690')
    bar_graph.title = 'Badge graph'#& QA graph'
    bar_graph.maximum_value = 500
    bar_graph.minimum_value = 0
    bar_graph.y_axis_increment = 20
    bar_graph.data('User Gold Badge',["#{@user_info["items"][0]["badge_counts"]["gold"]}".to_i])
    bar_graph.data('User Silver Badge', ["#{@user_info["items"][0]["badge_counts"]["silver"]}".to_i])
    bar_graph.data('User Bronze Badge',["#{@user_info["items"][0]["badge_counts"]["bronze"]}".to_i])
    #bar_graph.data('User Answer Count',["#{@user_answer_count}".to_i])
    #bar_graph.data('User Question Count',["#{@user_question_count}".to_i])
    bar_graph.write(image_url = "public/gruff_graph/elu_badge_qa_#{@user_info["items"][0]["user_id"]}_#{Time.now}.png")
    @graph = "#{image_url}"
    pdf.image @graph, :width => 550, :height => 690
    send_data pdf.render, type: "application/pdf", disposition: "inline"
  end
end