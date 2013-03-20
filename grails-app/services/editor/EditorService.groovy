package editor

class EditorService {

    private static final LinkedHashMap<String, Serializable> CONSTRAINTS = [sort: "createdDate", order: "desc", fetch: [author: "eager"]]

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
        Article.findAllByTitleLikeOrBodyLike(likeTerm, likeTerm, CONSTRAINTS)
    }

    List<Article> listArticlesForAuthor(Person person) {
        Article.findAllByAuthor(person, CONSTRAINTS)
    }
}
