package app

import com.vaadin.data.Property
import com.vaadin.data.util.BeanItem
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.event.ItemClickEvent
import com.vaadin.grails.Grails
import com.vaadin.server.Sizeable
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
            return ["title", "author", "createdDate"]
        }
    }

    private Table table = new Table()

    Component showBody() {

        HorizontalLayout topLayout = new HorizontalLayout()
        topLayout.setSizeFull()
        topLayout.setMargin(true)
        topLayout.setSpacing(true)

        Accordion accordion = createAccordion()
        topLayout.addComponent(accordion)
        topLayout.setExpandRatio(accordion, 1)

        HorizontalLayout horizontalLayout = createButtonLayout()
        topLayout.addComponent(horizontalLayout)
        topLayout.setExpandRatio(horizontalLayout, 0)

        return topLayout
    }

    private Accordion createAccordion() {
        Accordion accordion = new Accordion()
        accordion.setSizeFull()

        HorizontalLayout myContentTabLayout = new HorizontalLayout()
        accordion.addTab(myContentTabLayout, "My content")

        VerticalLayout contentTabLayout = createContentTabLayout()

        TabSheet.Tab tab = accordion.addTab(contentTabLayout, "Content")
        accordion.setSelectedTab(tab)
        return accordion
    }

    private VerticalLayout createContentTabLayout() {
        VerticalLayout contentTabLayout = new VerticalLayout()
        contentTabLayout.setSizeFull()

        TextField search = createSearchField()
        contentTabLayout.addComponent(search)
        contentTabLayout.setExpandRatio(search, 0)

        EditorService editorService = Grails.get(EditorService)
        List<Article> articles = editorService.listArticles()
        ArticleListContainer container = new ArticleListContainer(articles)

        table.setContainerDataSource(container)
        table.selectable = true
        table.addItemClickListener(new ItemClickEvent.ItemClickListener() {
            void itemClick(ItemClickEvent event) {
                BeanItem item = event.getItem()
                Component body = new EditorUI(parent: parent,
                        article: item.getBean()).createEditorBody()
                parent.switchIt(body)
            }
        })

        table.setSizeFull()
        contentTabLayout.addComponent(table)
        contentTabLayout.setExpandRatio(table, 1)
        return contentTabLayout
    }

    private TextField createSearchField() {
        TextField search = new TextField()
        search.immediate = true
        search.setInputPrompt("enter search term")
        search.setWidth(100, Sizeable.Unit.PERCENTAGE)
        search.addValueChangeListener(new Property.ValueChangeListener() {
            @Override
            void valueChange(Property.ValueChangeEvent valueChangeEvent) {
                EditorService editorService = Grails.get(EditorService)
                def articles = editorService.findArticles(search.value)
                ArticleListContainer container = new ArticleListContainer(articles)
                table.setContainerDataSource(container)
            }
        })
        return search
    }

    private HorizontalLayout createButtonLayout() {
        HorizontalLayout horizontalLayout = new HorizontalLayout()
        horizontalLayout.setSizeUndefined()
        Button button = new Button("Create article", new Button.ClickListener() {
            void buttonClick(Button.ClickEvent event) {
                parent.doUIAction(EditorUI.THIS_CHOICE)
            }
        })
        horizontalLayout.addComponent(button)
        return horizontalLayout
    }
}
