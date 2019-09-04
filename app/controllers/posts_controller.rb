class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_post, only: [:show]
    def index 
        @posts = Post.all.limit(50).includes(:photos, :user).order("created_at desc")
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            if params[:images]
                params[:images].each do |img|
        feed_back = @post.photos.create(image: img[1])
                    pp "________________________________________________"
                    pp "feed_back"
                    pp feed_back
                    pp "params[:images]"
                    pp params[:images]
                    pp "params[:images][img]"
                    pp params[:images][img]
                    pp "img.class"
                    pp img
                    pp "img"
                    pp img.class
                    pp "________________________________________________"
                end
            end
            
            redirect_to posts_path
            flash[:notice] = "Saved ..."
        else
            flash[:alert] = "Something went wrong ..."
            redirect_to posts_path
        end
    end

    def show
        @photos = @post.photos
    end

    private
        def find_post
            @post = Post.find_by id: params[:id]

            return if @post

            flash[:danger] = "Post not exist!"
            redirect_to root_path
        end
        def post_params
            params.require(:post).permit( :content)
        end
end