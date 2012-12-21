package editor

class EditorService {

    def saveNewArticle(Article article) {
        article.save()
    }

    def listArticles() {
        Article.listOrderByCreatedDate([order: "desc", fetch: [author: "eager"]])
    }

    def listTElements() {
        TElement.listOrderByParent()
    }
}
