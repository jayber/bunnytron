package editor.ws

import editor.Article

class ArticleRestController {

    def body(Long id) {
        render Article.get(id).body ?: ""
    }

    def bodySave(Long id) {
        Article article = Article.get(id)
        article.body = webRequest.getCurrentRequest().getInputStream().getText("UTF-8")
        article.save()
        render "Saved successfully..."
    }
}
