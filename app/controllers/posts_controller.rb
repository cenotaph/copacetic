class PostsController < ApplicationController
    before_filter :admin_required, :only=>[:destroy, :edit, :new, :update, :create]
    before_filter :login_required, :only => [:add_comment]
 
  
  def add_comment
    @post = Post.find(params[:id])
    @comment = @post.comments.create(params[:comment])
    @comment.date = Time.now
    @comment.user_id = current_user.id

    if @comment.save
     flash[:notice] = 'Your comment is awaiting approval.  Thanks!'
     redirect_to @post
   end
  end
                                 
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.published.order(created_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.rss  { render :rss => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.friendly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end


end
