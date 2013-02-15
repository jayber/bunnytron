package app

import com.vaadin.data.fieldgroup.FieldGroup
import com.vaadin.data.util.BeanItem
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.event.ItemClickEvent
import com.vaadin.grails.Grails
import com.vaadin.server.Sizeable
import com.vaadin.shared.ui.MarginInfo
import com.vaadin.shared.ui.datefield.Resolution
import com.vaadin.shared.ui.label.ContentMode
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
    Label html
    ContainerUI parent

    private VerticalLayout keywordLayout

    private top

    private Label titleLabel

    public Component createEditorBody() {

        VerticalLayout vlayout = new VerticalLayout()
        vlayout.setSizeFull()
        titleLabel = new Label()
        titleLabel.setStyleName(Reindeer.LABEL_H2)
        VerticalLayout layout = new VerticalLayout(titleLabel)
        layout.setMargin(true)
        vlayout.addComponent(layout)

        TabSheet tabSheet = new TabSheet()
        tabSheet.setSizeFull()
        vlayout.addComponent(tabSheet)
        vlayout.setExpandRatio(tabSheet, 100)

        Component componentTab = createContentTab()
        tabSheet.addTab(componentTab, "Content")

        tabSheet.addTab(createCodingTab(), "Coding")
        tabSheet.addSelectedTabChangeListener(new TabSheet.SelectedTabChangeListener() {
            void selectedTabChange(TabSheet.SelectedTabChangeEvent event) {
                if (event.getTabSheet().getSelectedTab() == componentTab) {
                    setUpCodeMirror()
                }
            }
        })

        HorizontalLayout buttonLayout = createButtonLayout()
        vlayout.addComponent(buttonLayout)
        vlayout.setComponentAlignment(buttonLayout, Alignment.BOTTOM_CENTER)

        return vlayout;
    }

    def Component createContentTab() {
        HorizontalLayout topLayout = new HorizontalLayout();
        topLayout.setSizeFull()

        VerticalLayout leftBodyLayout = createLeftBody()
        leftBodyLayout.setSizeFull()
        topLayout.addComponent(leftBodyLayout);

        VerticalLayout layout = createRightBody()
        layout.setSizeFull()
        topLayout.addComponent(layout)

        return topLayout
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

    private VerticalLayout createRightBody() {
        VerticalLayout bodyLayout = new VerticalLayout()
        bodyLayout.setMargin(true)
        bodyLayout.setSizeFull()

        Panel panel = new Panel("Preview")
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        layout.setMargin(true)
        panel.setContent(layout)
        panel.setSizeFull()

        html = new Label()
        html.setContentMode(ContentMode.HTML)
        html.setValue(article.body)
        layout.addComponent(html)

        bodyLayout.addComponent(panel)
        return bodyLayout
    }

    private VerticalLayout createLeftBody() {
        VerticalLayout bodyLayout = new VerticalLayout();
        bodyLayout.setSpacing(true)
        bodyLayout.setMargin(true)
        bodyLayout.setSizeFull()

        bodyLayout.addComponent(createForm());

        return bodyLayout
    }

    private HorizontalLayout createButtonLayout() {
        HorizontalLayout buttonLayout = new HorizontalLayout()
        buttonLayout.setMargin(new MarginInfo(false, false, false, true))
        buttonLayout.setSpacing(true)

        Button cancel = new Button("Cancel");
        cancel.addClickListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                goBack()
            }
        });
        buttonLayout.addComponent(cancel);
        buttonLayout.setComponentAlignment(cancel, Alignment.BOTTOM_LEFT)

        Button button = new Button("Save");
        button.addClickListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                fields.commit()
                EditorService editorService = Grails.get(EditorService)
                editorService.saveNewArticle(article)
                goBack()
            }
        });
        buttonLayout.addComponent(button);
        buttonLayout.setComponentAlignment(button, Alignment.BOTTOM_LEFT)
        buttonLayout.setExpandRatio(button, 100)
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

        TextArea body = new TextArea("Content")
        body.setValue(article.body)
        body.setId("editorArea")
        body.setImmediate(true)
        body.setWidth(100, Sizeable.Unit.PERCENTAGE)
        form.addComponent(body)

        setUpCodeMirror();
        return form
    }

    private void setUpCodeMirror() {
        JavaScript.getCurrent().execute(
                """
                editorArea = document.getElementById("editorArea");
                editor = CodeMirror.fromTextArea(editorArea, {
                    mode: 'text/xml',
                    lineNumbers: true,

                    extraKeys: {
                        "'>'": function(cm) { cm.closeTag(cm, '>'); },
                        "'/'": function(cm) { cm.closeTag(cm, '/'); }
                    },
                    wordWrap: true,
                    onChange : function(editor) {
                        updateBody(editor.getValue());
                    }
                });
            """
        )

        JavaScript.getCurrent().addFunction("updateBody", new JavaScriptFunction() {
            public void call(JSONArray arguments) throws JSONException {
                article.setBody(arguments.getString(0))
                html.setValue(article.getBody())
            }
        });
    }

}
