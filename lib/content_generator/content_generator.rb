module ContentGenerator

  def git_content_processor
    @github_user_name = request["git_name"]

    #Retrieving a github details
    @github_details = HTTParty.get("https://api.github.com/users/#{@github_user_name}?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf",:headers =>{"User-Agent" => "#{@github_user_name}"} )

    #organizations work
    @org_url = @github_details['organizations_url']
    @org_array =  Array.new()
    @org_name_array = Array.new()
    @org_array = HTTParty.get("#{@org_url}"+'?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf', :headers =>{"User-Agent" => "#{@github_user_name}"})
    if @org_array != nil
      @org_array.each { |name| @org_name_array << name['login']}
    else
      @org_array = nil
    end

    # detailed repo info
    @repo_info_link = @github_details['repos_url']
    @repo_info_array = Array.new()
    @repo_info_array = HTTParty.get("#{@repo_info_link}"+'?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
                                    :headers =>{"User-Agent" => "#{@github_user_name}"})
    @repo_req_info_array = Array.new()
    if @repo_info_array != nil
      @repo_info_array.each { |repo_info| @repo_req_info_array << "repo name : #{repo_info['name']},
                                                                   repo_url : #{repo_info['html_url']},
                                                                   repo description : #{repo_info['description']},
                                                                   forked? : #{repo_info['fork']},
                                                                   Stargazers Count : #{repo_info['stargazers_count']},
                                                                   Watchers Count : #{repo_info['watchers_count']},
                                                                   Forks Count : #{repo_info['forks_count']},
                                                                   Watchers : #{repo_info['watchers']},
                                                                   Language : #{repo_info['language']},
                                                                   Created At : #{repo_info['created_at']},
                                                                   Updated At : #{repo_info['updated_at']},
                                                                   Pushed At :#{repo_info['pushed_at']}"

        #contributions list
        # @repo_contributor = Array.new()
        # @repo_contributor_details = Array.new()
        # @repo_contributor = HTTParty.get("#{repo_info['contributors_url']}"+
        #                                      '?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
        #                                  :headers =>{"User-Agent" => "#{@github_user_name}"})
        # puts "*4#{@repo_contributor}++"
        # @repo_contributor_count = JSON.parse(@repo_contributor.body).count if @repo_contributor.code == 200
        # @repo_contributor_count = "#{@repo_contributor_count}"+'+' if @repo_contributor_count >=30
        # @repo_req_info_array << "Contributors Count :#{@repo_contributor_count}"
        #
        # #commits details
        # @repo_commits_url_process = repo_info['commits_url'].gsub('{/sha}','')
        # @repo_commits_details = HTTParty.get("#{@repo_commits_url_process}"+
        #                                          '?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
        #                                      :headers =>{"User-Agent" => "#{@github_user_name}"})
        # puts "*5#{@repo_commits_details}++"
        # @repo_commits_count = JSON.parse(@repo_commits_details.body).count
        # @repo_commits_count = "#{@repo_commits_count}"+'+' if @repo_commits_count >=30
        # @repo_req_info_array << "Commits Count :#{@repo_commits_count}"
      }

    else
      @repo_info_array = nil
    end
  end

  def sof_content_processor
      @user_id = request["sof_user_id"]

      #/users/{ids}
      @user_info = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}?order=desc&sort=reputation&site=stackoverflow")

      #/users/{ids}/answers
      @user_answer = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/answers?order=desc&sort=activity&site=stackoverflow")
      @user_answer_count = @user_answer["items"].count
      @answer_collect = Array.new()
      if @user_answer["items"] != nil
        @user_answer["items"].each { |item| @answer_collect << "http://stackoverflow.com/q/#{item["answer_id"]}" }
      else
        @user_answer["items"] = nil
      end

      #/users/{ids}/questions
      @user_question = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/questions?order=desc&sort=activity&site=stackoverflow")
      @user_question_count = @user_question["items"].count
      @question_collect = Array.new()
      if @user_question["items"] != nil
        @user_question["items"].each { |item| @question_collect << "http://stackoverflow.com/q/#{item["question_id"]}" }
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
        @user_tags["items"].each { |tag| @user_tags_info_hash["#{tag["name"]}"] = tag["count"] }
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

  end

  def gblogger_content_processor
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
  end

  def linkedin_content_processor
    # getting public profile url from user
    url = request['lin_p_p_url']
    if url.include?('https://www')
      url = url.gsub('https://www.', 'https://')
    elsif url.include?('https')
      url
    elsif url.include?('http')
      url = url.gsub('http', 'https')
    elsif url.include?('www')
      url = url.gsub('www.', 'https://')
    else
      url = 'https://'+url
    end
    #detting public profile info from linkedin
    profile_info = Linkedin::Profile.get_profile("#{url}")
    @pro_info_hash = {'First Name' => profile_info.first_name, 'Last Name' => profile_info.last_name, 'Name' => profile_info.name,
                       'Title' => profile_info.title, 'Summary' => profile_info.summary, 'Location' => profile_info.location,
                       'Country' => profile_info.country, 'Industry' => profile_info.industry, 'skills' => profile_info.skills,
                       'Websites' => profile_info.websites}

    @others = {'Organizations' => profile_info.organizations, 'Languages' => profile_info.languages, 'Certifications' => profile_info.certifications}

    @pro_info_hash_array = { 'Education' => profile_info.education, 'Groups' => profile_info.groups, 'Past_Companies' => profile_info.past_companies,
                             'Current_Companies' => profile_info.current_companies}
  end

  def bit_b_content_processor
    @bit_b_name = request["bit_b_username"]

    #retriving user info
    @bit_b_user_details = HTTParty.get("https://bitbucket.org/api/2.0/users/#{@bit_b_name}/")

    #retriving user followers
    @bit_b_user_follower_array = HTTParty.get("https://bitbucket.org/api/2.0/users/#{@bit_b_name}/followers?pagelen=100")
    @bit_b_u_f_a = Array.new()
    if !@bit_b_user_follower_array['values'].blank?
      @bit_b_user_follower_array['values'].each {|f| @bit_b_u_f_a << f['username'] }
    end

    #retriving user followings
    @bit_b_user_following_array = HTTParty.get("https://bitbucket.org/api/2.0/users/#{@bit_b_name}/following?pagelen=100")
    @bit_b_u_fg_a = Array.new()
    if !@bit_b_user_following_array['values'].blank?
      @bit_b_user_following_array['values'].each {|f| @bit_b_u_fg_a << f['username'] }
    end

    #retriving repo info
    @bit_b_user_repo_info = HTTParty.get("https://bitbucket.org/api/2.0/repositories/#{@bit_b_name}?pagelen=100")
    @bit_b_repo_count = @bit_b_user_repo_info['values'].count
    @bit_b_user_repo_info_array = Array.new()
    if @bit_b_repo_count > 0
      @bit_b_user_repo_info['values'].each{|r| @bit_b_user_repo_info_array << "Project Name = #{r['name']},
                                                                               Description = #{r['description']},
                                                                               Project URL = #{r['links']['html']['href']},
                                                                               Version Controller = #{r['scm']},
                                                                               Language  = #{r['language']},
                                                                               Created On = #{r['created_on']},
                                                                               Has Issues = #{r['has_issues']},
                                                                               Project Owner = #{r['owner']['username']},
                                                                               Updated On = #{r['updated_on']},
                                                                               Watchers Count = #{(HTTParty.get("#{r['links']['watchers']['href']}"))['values'].count},
                                                                               Commits Count = #{(HTTParty.get("#{r['links']['commits']['href']}"))['values'].count},
                                                                               Forks Count = #{(HTTParty.get("#{r['links']['forks']['href']}"))['values'].count} "
                                                                                }
    end
  end

  def prog_content_processor
    @user_id = request["prog_user_id"]

    #/users/{ids}
    @user_info = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}?order=desc&sort=reputation&site=programmers")

    #/users/{ids}/answers
    @user_answer = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/answers?order=desc&sort=activity&site=programmers")
    @user_answer_count = @user_answer["items"].count
    @answer_collect = Array.new()
    if @user_answer["items"] != nil
      @user_answer["items"].each { |item| @answer_collect << "http://programmers.stackexchange.com/q/#{item["answer_id"]}" }
    else
      @user_answer["items"] = nil
    end

    #/users/{ids}/questions
    @user_question = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/questions?order=desc&sort=activity&site=programmers")
    @user_question_count = @user_question["items"].count
    @question_collect = Array.new()
    if @user_question["items"] != nil
      @user_question["items"].each { |item| @question_collect << "http://programmers.stackexchange.com/q/#{item["question_id"]}" }
    else
      @user_question["items"] = nil
    end

    #/users/{id}/network-activity
    @user_network_activity = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_info["items"][0]["account_id"]}/network-activity")
    @user_network_activity_count = @user_network_activity["items"].count

    #/users/{ids}/reputation-history
    @user_reputation_history = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/reputation-history?site=programmers")
    @user_reputation_array = Array.new()
    if @user_reputation_history["items"] != nil
      @user_reputation_history["items"].each { |repu| @user_reputation_array << repu["reputation_change"] }
    else
      @user_reputation_history["items"] = nil
    end

    #/users/{ids}/tags
    @user_tags = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/tags?order=desc&sort=popular&site=programmers")
    @user_tags_info_hash = Hash.new()
    if @user_tags["items"] != nil
      @user_tags["items"].each { |tag| @user_tags_info_hash["#{tag["name"]}"] = tag["count"] }
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
    @user_timeline = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/timeline?site=programmers")
    @user_timeline_count = @user_timeline["items"].count

  end


end