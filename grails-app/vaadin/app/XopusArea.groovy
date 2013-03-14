package app

import com.vaadin.ui.CustomLayout
import editor.Article

class XopusArea extends CustomLayout implements EditorArea {
    static String FRAME_START = "<iframe src=\"/frame/show?id="
    static String FRAME_END = "\" width=\"100%\" height=\"1000\" frameborder=\"0\"></iframe>"

    private Article article

    XopusArea(Article article) {
        super(new ByteArrayInputStream((FRAME_START + article.id + FRAME_END).getBytes()))
        this.article = article
    }

    @Override
    void setUp() {
    }
}
