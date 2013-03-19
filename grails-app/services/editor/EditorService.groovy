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

    def findArticles(String term) {
        String likeTerm = "%" + term + "%"
        Article.findAllByTitleLikeOrBodyLike(likeTerm, likeTerm, [sort: "createdDate", order: "desc", fetch: [author: "eager"]])
    }
}
