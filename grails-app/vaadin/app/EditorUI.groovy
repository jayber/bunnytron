package app

import com.vaadin.data.fieldgroup.FieldGroup
import com.vaadin.data.util.BeanItem
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.grails.Grails
import com.vaadin.shared.ui.datefield.Resolution
import com.vaadin.shared.ui.label.ContentMode
import com.vaadin.ui.*
import editor.Article
import editor.EditorService
import editor.Person
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

    public HorizontalLayout createEditorBody() {
        HorizontalLayout topLayout = new HorizontalLayout();
        topLayout.setSizeFull()

        VerticalLayout leftBodyLayout = createLeftBody()
        leftBodyLayout.setSizeFull()
        topLayout.addComponent(leftBodyLayout);

        VerticalLayout layout = createRightBody()
        layout.setSizeFull()
        topLayout.addComponent(layout)

        return topLayout;
    }

    private VerticalLayout createRightBody() {
        VerticalLayout bodyLayout = new VerticalLayout()
        bodyLayout.setMargin(true)
        bodyLayout.setSizeFull()

        Panel panel = new Panel("Content")
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

        HorizontalLayout buttonLayout = new HorizontalLayout()
        buttonLayout.setSizeFull()
        bodyLayout.addComponent(buttonLayout)
        bodyLayout.setComponentAlignment(buttonLayout, Alignment.BOTTOM_CENTER)

        Button cancel = new Button("cancel");
        cancel.addClickListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                parent.switchBodies(ArticleListUI.THIS_CHOICE)
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
            }
        });
        buttonLayout.addComponent(button);
        buttonLayout.setComponentAlignment(button, Alignment.BOTTOM_RIGHT)

        return bodyLayout
    }

    Component createForm() {
        fields = new FieldGroup(new BeanItem(article))
        VerticalLayout form = new VerticalLayout();
        form.setSizeUndefined()
        DateField createdDate = new DateField("Created Date")
        createdDate.setResolution(Resolution.MINUTE)
        fields.bind(createdDate, "createdDate")
        form.addComponent(createdDate)

        form.addComponent(fields.buildAndBind("title"))

        ComboBox author = new ComboBox("Author", new BeanItemContainer<Person>(Person.list()))
        author.setNullSelectionAllowed(false)
        author.setRequired(true)
        fields.bind(author, "author")
        form.addComponent(author)

        TextArea body = new TextArea("Content")
        fields.bind(body, "body")
        body.setWidth("100%")
        body.setId("editorArea")
        body.setImmediate(true)
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
