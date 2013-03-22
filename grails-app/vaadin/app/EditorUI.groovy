package app

import com.vaadin.data.fieldgroup.FieldGroup
import com.vaadin.data.util.BeanItem
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.event.ItemClickEvent
import com.vaadin.event.LayoutEvents
import com.vaadin.grails.Grails
import com.vaadin.server.ExternalResource
import com.vaadin.server.Sizeable
import com.vaadin.shared.ui.MarginInfo
import com.vaadin.shared.ui.datefield.Resolution
import com.vaadin.ui.*
import com.vaadin.ui.themes.Reindeer
import editor.Article
import editor.EditorService
import editor.Person
import editor.TElement
import org.json.JSONArray
import org.json.JSONException

/**
 * User: James
 * Date: 15/12/12
 */
class EditorUI {

    public static final String THIS_CHOICE = "editor"
    Article article = new Article()
    FieldGroup fields
    ContainerUI parent

    private VerticalLayout keywordLayout

    private top

    private Label titleLabel

    private EditorArea editorArea

    private Label statusLabel

    private HorizontalLayout buttonLayout

    private Embedded rightArrow = new Embedded("", new ExternalResource("/images/right_arrow.png"))

    private Embedded downArrow = new Embedded("", new ExternalResource("/images/down_arrow.png"))

    private HorizontalLayout titleLayout

    public Component createEditorBody() {

        VerticalLayout vlayout = new VerticalLayout()
        vlayout.setSizeFull()
        titleLabel = new Label()
        titleLabel.setStyleName(Reindeer.LABEL_H2)

        titleLayout = new HorizontalLayout(rightArrow, titleLabel)
        titleLayout.setComponentAlignment(rightArrow, Alignment.BOTTOM_LEFT)
        titleLayout.setComponentAlignment(titleLabel, Alignment.BOTTOM_LEFT)
        titleLayout.setMargin(true)
        titleLayout.addStyleName("homeLink")
        titleLayout.setDescription("Click to edit details")
        vlayout.addComponent(titleLayout)

        final detailsLayout = createDetailsLayout()
        vlayout.addComponent(detailsLayout)

        titleLayout.addLayoutClickListener(new LayoutEvents.LayoutClickListener() {
            @Override
            void layoutClick(LayoutEvents.LayoutClickEvent event) {
                detailsLayout.visible = !detailsLayout.visible
                if (detailsLayout.visible) {
                    titleLayout.replaceComponent(rightArrow, downArrow)
                } else {
                    titleLayout.replaceComponent(downArrow, rightArrow)
                }
            }
        })

        TabSheet tabSheet = new TabSheet()
        tabSheet.setSizeFull()
        vlayout.addComponent(tabSheet)
        vlayout.setExpandRatio(tabSheet, 1)

        Component componentTab = createEditorArea()
        tabSheet.addTab(componentTab, "Content")

        tabSheet.addTab(createCodingTab(), "Classification")
        tabSheet.addSelectedTabChangeListener(new TabSheet.SelectedTabChangeListener() {
            void selectedTabChange(TabSheet.SelectedTabChangeEvent event) {
                if (event.getTabSheet().getSelectedTab() == componentTab) {
                    editorArea.setUp()
                }
            }
        })

        HorizontalLayout buttonLayout = createButtonLayout()
        vlayout.addComponent(buttonLayout)
        vlayout.setComponentAlignment(buttonLayout, Alignment.BOTTOM_LEFT)

        return vlayout;
    }

    def Component createCodingTab() {
        HorizontalLayout horizontalLayout = new HorizontalLayout()
        horizontalLayout.setMargin(true)
        horizontalLayout.setSpacing(true)
        horizontalLayout.setSizeFull()

        horizontalLayout.addComponent(createTaxonomyTree())

        def keyWordPanel = new Panel("Keywords")
        keyWordPanel.setSizeFull()
        keywordLayout = new VerticalLayout()
        keyWordPanel.setContent(keywordLayout)
        horizontalLayout.addComponent(keyWordPanel)
        horizontalLayout.setExpandRatio(keyWordPanel, 100)
        return horizontalLayout
    }

    def VerticalLayout createTaxonomyTree() {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        layout.setHeight("100%")

        Panel panel = new Panel("Taxonomy tree")
        panel.setSizeUndefined()
        panel.setHeight("100%")
        layout.addComponent(panel)

        def tree = new Tree("(double-click to add)")
        tree.setSelectable(true)
        VerticalLayout panelLayout = new VerticalLayout()
        panel.setContent(panelLayout)
        panelLayout.addComponent(tree)

        EditorService editorService = Grails.get(EditorService)
        List<TElement> elements = editorService.listTElements()

        elements.each { TElement it ->
            addTreeItem(it, tree)
        }

        elements.each { TElement it ->
            if (!tree.hasChildren(it)) {
                tree.setChildrenAllowed(it, false)
            }
        }

        tree.addItemClickListener(new ItemClickEvent.ItemClickListener() {
            void itemClick(ItemClickEvent event) {
                if (event.isDoubleClick()) {
                    addKeyword(event.itemId)
                }
            }
        })

        tree.expandItemsRecursively(top)
        return layout
    }

    def addTreeItem(TElement it, Tree tree) {
        if (!tree.containsId(it)) {
            tree.addItem(it)
            if (it.parent != null) {
                addTreeItem(it.parent, tree)
                tree.setParent(it, it.parent)
            } else {
                top = it
            }
        }
    }


    def addKeyword(TElement element) {
        keywordLayout.addComponent(new Label(element.name))
    }

    private VerticalLayout createDetailsLayout() {
        VerticalLayout bodyLayout = new VerticalLayout();
        bodyLayout.setSpacing(true)
        bodyLayout.setMargin(new MarginInfo(false, true, true, true))
        bodyLayout.setSizeUndefined()
        bodyLayout.visible = false

        bodyLayout.addComponent(createForm());

        return bodyLayout
    }

    private HorizontalLayout createButtonLayout() {
        buttonLayout = new HorizontalLayout()
        buttonLayout.setMargin(new MarginInfo(false, true, false, true))
        buttonLayout.setSpacing(true)
        buttonLayout.setWidth("100%")

        Button button = new Button("Save & close");
        button.addClickListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                saveArticle()
                goBack()
            }
        });
        buttonLayout.addComponent(button);
        buttonLayout.setExpandRatio(button, 0)
        buttonLayout.setComponentAlignment(button, Alignment.BOTTOM_LEFT)

        statusLabel = new Label("Opened...")
        statusLabel.setSizeUndefined();
        buttonLayout.addComponent(statusLabel)
        buttonLayout.setExpandRatio(statusLabel, 0)
        buttonLayout.setComponentAlignment(statusLabel, Alignment.MIDDLE_RIGHT)

        JavaScript.getCurrent().addFunction("updateStatus", new JavaScriptFunction() {
            public void call(JSONArray arguments) throws JSONException {
                statusLabel.setValue(arguments.getString(0) + " at " + (new Date()).format("HH:mm:ss, dd/MM/yyyy"))
            }
        });

        return buttonLayout
    }

    void goBack() {
        parent.doUIAction(ArticleListUI.THIS_CHOICE)
    }

    Component createForm() {
        fields = new FieldGroup(new BeanItem(article))
        VerticalLayout form = new VerticalLayout();
        form.setWidth(100, Sizeable.Unit.PERCENTAGE)
        DateField createdDate = new DateField("Created Date")
        createdDate.setResolution(Resolution.MINUTE)
        fields.bind(createdDate, "createdDate")
        form.addComponent(createdDate)

        TextField bind = fields.buildAndBind("title")
        titleLabel.setPropertyDataSource(bind)
        form.addComponent(bind)

        ComboBox author = new ComboBox("Author", new BeanItemContainer<Person>(Person.list()))
        author.setNullSelectionAllowed(false)
        author.setRequired(true)
        fields.bind(author, "author")
        form.addComponent(author)

        CheckBox maintainFlag = new CheckBox("Maintain?")
        fields.bind(maintainFlag, "maintained")
        form.addComponent(maintainFlag)

        DateField maintainDate = new DateField("Maintain Date")
        maintainDate.setResolution(Resolution.MINUTE)
        fields.bind(maintainDate, "maintainDate")
        form.addComponent(maintainDate)

        ComboBox service = new ComboBox("Service", new BeanItemContainer<TElement>(TElement.list()))
        service.setNullSelectionAllowed(false)
        service.setRequired(true)
        fields.bind(service, "service")
        form.addComponent(service)

        return form
    }

    private EditorArea createEditorArea() {
        editorArea = new XopusArea(article)
        editorArea.setWidth(100, Sizeable.Unit.PERCENTAGE)
        editorArea.setHeight(99, Sizeable.Unit.PERCENTAGE)
        return editorArea
    }


    private void saveArticle() {
        fields.commit()
        EditorService editorService = Grails.get(EditorService)
        editorService.saveNewArticle(article)
    }
}
