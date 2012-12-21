package app

import com.vaadin.data.util.BeanItem
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.event.ItemClickEvent
import com.vaadin.grails.Grails
import com.vaadin.ui.*
import editor.Article
import editor.EditorService

/**
 * User: James
 * Date: 18/12/12
 */
class ArticleListUI {

    public static final String THIS_CHOICE = "list"
    ContainerUI parent

    class ArticleListContainer extends BeanItemContainer {
        protected ArticleListContainer(List<Article> articles) {
            super(Article.class, articles)
        }

        @Override
        Collection<String> getContainerPropertyIds() {
            return ["title", "author", "body", "createdDate"]
        }
    }

    Component showBody() {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeFull()
        layout.setMargin(true)
        layout.setSpacing(true)

        HorizontalLayout horizontalLayout = new HorizontalLayout()
        horizontalLayout.setSizeUndefined()
        Button button = new Button("Create article", new Button.ClickListener() {
            void buttonClick(Button.ClickEvent event) {
                parent.doUIAction(EditorUI.THIS_CHOICE)
            }
        })
        horizontalLayout.addComponent(button)
        layout.addComponent(horizontalLayout)

        EditorService editorService = Grails.get(EditorService)
        List<Article> articles = editorService.listArticles()
        ArticleListContainer container = new ArticleListContainer(articles)

        Table table = new Table("Articles (double-click to open)", container)
        table.setSizeFull()
        table.selectable = true
        table.addItemClickListener(new ItemClickEvent.ItemClickListener() {
            void itemClick(ItemClickEvent event) {
                if (event.isDoubleClick()) {
                    BeanItem item = event.getItem()
                    Component body = new EditorUI(parent: parent,
                            article: item.getBean()).createEditorBody()
                    parent.switchIt(body)
                }
            }
        })

        VerticalLayout vlayout = new VerticalLayout(table)
        vlayout.setSizeFull()
        layout.addComponent(vlayout)
        layout.setExpandRatio(vlayout, 100)

        return layout
    }
}
