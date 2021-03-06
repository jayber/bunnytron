package app

import com.vaadin.data.Property
import com.vaadin.data.util.BeanItem
import com.vaadin.event.ItemClickEvent
import com.vaadin.grails.Grails
import com.vaadin.server.ExternalResource
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
        TabSheet.Tab tab = accordion.addTab(myContentTabLayout, "My content")

        VerticalLayout contentTabLayout = createContentTabLayout()

        accordion.addTab(contentTabLayout, "All content")
        accordion.setSelectedTab(tab)
        return accordion
    }

    private Layout createMyContentTab() {

        HorizontalLayout myContentTabLayout = new HorizontalLayout()
        myContentTabLayout.setSizeFull()
        myContentTabLayout.setSpacing(true)


        EditorService editorService = Grails.get(EditorService)
        List<Article> authorsArticles = editorService.listArticlesForAuthor(author)
        Table mostRecentTable = createArticleTable(authorsArticles, "My articles", ["title", "service", "maintained"])

        final mostRecentLayout = new VerticalLayout()
        mostRecentLayout.setSizeFull()
        mostRecentLayout.addComponent(mostRecentTable)

        myContentTabLayout.addComponent(mostRecentLayout)


        authorsArticles = editorService.listMaintainedArticles()
        Table maintainedTable = createArticleTable(authorsArticles, "Maintained articles", ["title", "service", "maintainDate"])
        maintainedTable.setCellStyleGenerator(new Table.CellStyleGenerator() {
            @Override
            String getStyle(Table source, Object itemId, Object property) {
                if (itemId.maintainDate.before(new Date())) {
                    return "red"
                }
                return "green"
            }
        })
        myContentTabLayout.addComponent(maintainedTable)

        authorsArticles = editorService.listArticlesForService(author.service)
        myContentTabLayout.addComponent(createArticleTable(authorsArticles, "Articles in your service: ${author.service}", ["title", "author", "createdDate"]))

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
        NamedColumnFieldContainer container = new NamedColumnFieldContainer(articles, columnFields, Article.class)
        final Table table = new Table(caption)
        table.setSizeFull()

        table.setContainerDataSource(container)
        table.selectable = true
        table.setSizeUndefined()
        table.setColumnWidth(columnFields[0], 130)
        table.addItemClickListener(new ItemClickEvent.ItemClickListener() {
            void itemClick(ItemClickEvent event) {
                BeanItem item = event.getItem()
                Component body = new EditorUI(parent: parent,
                        article: item.getBean()).createEditorBody()
                parent.switchIt(body)
            }
        })

        table.setSizeFull()
        if (columnFields.contains("maintained")) {
            table.addGeneratedColumn("maintained", new Table.ColumnGenerator() {
                @Override
                Object generateCell(Table source, Object itemId, Object columnId) {
                    new Image(null, new ExternalResource(itemId.maintained ? "/images/tick.png" : "/images/cross.png"))
                }
            })
        }


        columnFields.findAll { it.contains("Date") } each { columnName ->
            table.addGeneratedColumn(columnName, new Table.ColumnGenerator() {
                @Override
                Object generateCell(Table source, Object itemId, Object columnId) {
                    itemId.properties[columnId]?.format("dd/MM/yy HH:mm")
                }
            })
        }
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
                NamedColumnFieldContainer container = new NamedColumnFieldContainer(articles, ["title", "author", "createdDate"], Article.class)
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
