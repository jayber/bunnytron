package app

import com.vaadin.data.util.AbstractBeanContainer
import com.vaadin.data.util.BeanContainer
import com.vaadin.data.util.BeanItem
import com.vaadin.grails.Grails
import com.vaadin.ui.Component
import com.vaadin.ui.Table
import com.vaadin.ui.VerticalLayout
import editor.Article
import editor.EditorService

/**
 * User: James
 * Date: 18/12/12
 */
class ArticleListUI {

    class ArticleListContainer extends AbstractBeanContainer {
        protected ArticleListContainer(Class type) {
            super(Article.class)
        }
    }

    Component showBody() {

        EditorService editorService = Grails.get(EditorService)
        List<Article> articles = editorService.listArticles()

        BeanContainer container = new BeanContainer(Article.class)

        for (article in articles) {
            container.addBean(new BeanItem<Article>(article, ["title", "body"]))
        }

        Table table = new Table("Articles", container)

        return new VerticalLayout(table)
    }
}
