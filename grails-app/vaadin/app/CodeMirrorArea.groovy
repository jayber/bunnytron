package app

import com.vaadin.server.Sizeable
import com.vaadin.ui.JavaScript
import com.vaadin.ui.JavaScriptFunction
import com.vaadin.ui.Label
import com.vaadin.ui.TextArea
import editor.Article
import org.json.JSONArray
import org.json.JSONException

class CodeMirrorArea extends TextArea implements EditorArea {
    Article article
    Label html

    CodeMirrorArea(Article article, Label html) {
        super()
        this.html = html
        this.article = article
        setUpTextArea()
    }

    private void setUpTextArea() {
        this.setValue(article.body)
        this.setId("editorArea")
        this.setImmediate(true)
        this.setWidth(100, Sizeable.Unit.PERCENTAGE)

        setUpCodeMirror(article, html);
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
