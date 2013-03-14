package app

import com.vaadin.server.Sizeable
import com.vaadin.shared.ui.label.ContentMode
import com.vaadin.ui.*
import editor.Article
import org.json.JSONArray
import org.json.JSONException

class CodeMirrorArea extends HorizontalLayout implements EditorArea {
    Article article
    Label html = new Label()

    CodeMirrorArea(Article article) {
        super()
        this.article = article
        this.setWidth(100, Sizeable.Unit.PERCENTAGE)
        setUpTextArea()
    }

    private void setUpTextArea() {
        def area = new TextArea()
        area.setValue(article.body)
        area.setId("editorArea")
        area.setImmediate(true)
        area.wordwrap = Boolean.TRUE;
        area.setWidth(100, Sizeable.Unit.PERCENTAGE)
        this.addComponent(area)
        this.addComponent(createRightBody())

        setUpCodeMirror(article, html);
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

        html.setContentMode(ContentMode.HTML)
        html.setValue(article.body)
        layout.addComponent(html)

        bodyLayout.addComponent(panel)
        return bodyLayout
    }

    @Override
    void setUp() {
        setUpCodeMirror(article, html)
    }

    private void setUpCodeMirror(Article article, Label html) {
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
