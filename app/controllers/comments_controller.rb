class CommentsController < ApplicationController
    before_action :set_comment, only: [:update, :destroy]
    before_action :set_article
    before_action :authenticate_user! #, except: [:show, :index]

    def create
        @comment = current_user.comments.new(comment_params)
        @comment.article = @article
        respond_to do |format|
            if @comment.save
                format.html { redirect_to @comment.article, notice: 'Comment was successfully created.' }
                format.json { render :show, status: :created, location: @comment.article }
            else
                format.html { render :new }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @comment.update(comment_params)
                format.html { redirect_to @comment.article, notice: 'Comment was successfully updated.' }
                format.json { render :show, status: :ok, location: @comment }
            else
                format.html { render :new }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
        
        respond_with(@article)
    end

    def destroy
        @comment.destroy
        respond_with(@article)
    end

    private
        def set_article
          @article = Article.find(params[:article_id])    
        end
        def set_comment
          @comment = Comment.find(params[:id])
        end

        def comment_params
          params.require(:comment).permit(:user_id, :article_id, :body)
        end
end
