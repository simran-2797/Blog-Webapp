class ArticlesController < ApplicationController
before_action :set_article, only: [:edit, :update, :show, :destroy]
before_action :require_user, except: [:index, :show]
before_action :require_same_user, only: [:edit, :update, :destroy]

    def destroy
        
        @article.destroy
        flash[:danger] = "This article was deleted"
        redirect_to articles_path
    end

    def index
        @articles = Article.paginate(page: params[:page], per_page: 5)
    end
    
    def new
        @article = Article.new
    end
    def edit
       
    end
    def update
       
        if @article.update(article_params)
            flash[:success] = "The article is sucessfully edited"
            redirect_to article_path(@article)
        else
            render 'edit'
        end
    end
    def create
        #render plain: params[:article].inspect
        @article = Article.new(article_params)
        @article.user = current_user
        @article.save
        if @article.save 
            flash[:success] = "Successfully saved..."
            redirect_to article_path(@article)
        else
            render 'new'
        end
    end
    def show

    end
    private
    def article_params
        params.require(:article).permit(:title,:description)
    end
    def set_article
        @article = Article.find(params[:id]) 
    end
    def require_same_user
        if current_user != @article.user and !current_user.admin?
            flash[:danger] = "You can only edit and delete your own articles"
        end
    end



end
