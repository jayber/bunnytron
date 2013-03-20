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
import editor.Person

/**
 * User: James
 * Date: 18/12/12
 */
class ArticleListUI {

    public static final String THIS_CHOICE = "list"
    ContainerUI parent
    Person author

    class ArticleListContainer extends BeanItemContainer {
        private ArrayList<String> propertyIds

        protected ArticleListContainer(List<Article> articles, ArrayList<String> columnFields) {
            super(Article.class, articles)
            propertyIds = columnFields
        }

        @Override
        Collection<String> getContainerPropertyIds() {
            return propertyIds
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

        Layout myContentTabLayout = createMyContentTab()
        accordion.addTab(myContentTabLayout, "My content")

        VerticalLayout contentTabLayout = createContentTabLayout()

        TabSheet.Tab tab = accordion.addTab(contentTabLayout, "All content")
        accordion.setSelectedTab(tab)
        return accordion
    }

    private Layout createMyContentTab() {

        HorizontalLayout myContentTabLayout = new HorizontalLayout()
        myContentTabLayout.setSizeFull()
        myContentTabLayout.setSpacing(true)


        EditorService editorService = Grails.get(EditorService)
        List<Article> articles = editorService.listArticlesForAuthor(author)
        Table mostRecentTable = createArticleTable(articles, "Most recent", ["title", "createdDate", "service"])
        final mostRecentLayout = new VerticalLayout()
        mostRecentLayout.setSizeFull()
        mostRecentLayout.addComponent(mostRecentTable)

        myContentTabLayout.addComponent(mostRecentLayout)


        articles = editorService.listMaintainedArticles()
        final VerticalLayout maintainLayout = new VerticalLayout(createArticleTable(articles, "Maintenance", ["title", "service", "maintainDate"]))
        maintainLayout.setMargin(true)
        maintainLayout.setSizeFull()
        myContentTabLayout.addComponent(maintainLayout)

        articles = editorService.listArticlesForService(author.service)
        myContentTabLayout.addComponent(createArticleTable(articles, "Service", ["title", "author", "createdDate"]))

        return myContentTabLayout
    }

    private VerticalLayout createContentTabLayout() {
        VerticalLayout contentTabLayout = new VerticalLayout()
        contentTabLayout.setSizeFull()

        TextField search = createSearchField()
        contentTabLayout.addComponent(search)
        contentTabLayout.setExpandRatio(search, 0)

        table = createListAllContentTable(null)
        contentTabLayout.addComponent(table)
        contentTabLayout.setExpandRatio(table, 1)
        return contentTabLayout
    }

    private Table createListAllContentTable(String caption) {
        List<Article> articles = listAllArticles()
        return createArticleTable(articles, caption, ["title", "author", "service", "maintained", "createdDate", "maintainDate"])
    }

    private Table createArticleTable(List<Article> articles, String caption, ArrayList<String> columnFields) {
        ArticleListContainer container = new ArticleListContainer(articles, columnFields)
        Table table = new Table(caption)
        table.setSizeFull()

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
        return table
    }

    private List<Article> listAllArticles() {
        EditorService editorService = Grails.get(EditorService)
        List<Article> articles = editorService.listArticles()
        return articles
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
                ArticleListContainer container = new ArticleListContainer(articles, ["title", "author", "createdDate"])
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
