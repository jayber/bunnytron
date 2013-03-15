package app

import com.vaadin.server.ExternalResource
import com.vaadin.ui.BrowserFrame
import editor.Article

class XopusArea extends BrowserFrame implements EditorArea {
    private static String FRAME_URL = "/frame/show?id="

    private Article article

    XopusArea(Article article) {
        super("", new ExternalResource(FRAME_URL + article.id))
        this.article = article
    }

    @Override
    void setUp() {
    }
}
