package editor

class EditorService {

    def saveNewArticle(Article article) {
        article.save()
    }

    def listArticles() {
        Article.list([fetch: [author: "eager"]])
    }
}
