package app

import com.vaadin.ui.CustomLayout
import com.vaadin.ui.JavaScript
import com.vaadin.ui.Label
import editor.Article

class XopusArea extends CustomLayout implements EditorArea {
    private Article article
    private Label label
    private static String TEMPLATE_FILENAME = "xopusTemplate.html"

    XopusArea(Article article, Label label) {
        super(Thread.currentThread().getContextClassLoader().getResourceAsStream(TEMPLATE_FILENAME))
        this.label = label
        this.article = article
    }

    @Override
    void setUp() {

        JavaScript.getCurrent().execute(
                """
                var editorScript = document.createElement("script");
                editorScript.setAttribute("src","/xopus/xopus/xopus.js");
                document.body.appendChild(editorScript);
                """
        )
    }
}
