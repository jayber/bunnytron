package app

import com.vaadin.annotations.StyleSheet
import com.vaadin.annotations.Theme
import com.vaadin.event.LayoutEvents
import com.vaadin.server.ExternalResource
import com.vaadin.server.Page
import com.vaadin.server.VaadinRequest
import com.vaadin.shared.ui.MarginInfo
import com.vaadin.shared.ui.label.ContentMode
import com.vaadin.ui.*
import com.vaadin.ui.themes.Reindeer

import java.text.SimpleDateFormat

@Theme("reindeer")
@com.vaadin.annotations.JavaScript([
"http://localhost:8080/codemirror/lib/codemirror.js",
"http://localhost:8080/codemirror/mode/xml/xml.js",
"http://localhost:8080/codemirror/lib/util/closetag.js",
"http://localhost:8080/codemirror/lib/util/foldcode.js",
"http://localhost:8080/codemirror/lib/util/simple-hint.js",
"http://localhost:8080/codemirror/lib/util/formatting.js",
"http://localhost:8080/codemirror/lib/util/xml-hint.js"
])
@StyleSheet([
"http://localhost:8080/codemirror/lib/codemirror.css",
"http://localhost:8080/css/editor.css",
"http://localhost:8080/codemirror/theme/neat.css"
])
class ContainerUI extends UI {

    public static final String CHOICE_CHOICE = "choice"
    private VerticalLayout root

    def bodies =
        [
                (CHOICE_CHOICE): { new ChoiceUI(container: this).createChoiceBody() },
                (ArticleListUI.THIS_CHOICE): { new ArticleListUI(parent: this).showBody() },
                (EditorUI.THIS_CHOICE): { new EditorUI(parent: this).createEditorBody() },
                (ChoiceUI.SITE_CHOICE): { new EditorUI().createEditorBody() }
        ]

    private Component currentBody

    @Override
    protected void init(VaadinRequest request) {
        root = new VerticalLayout()
        root.setSizeFull()
        setContent(root)
        root.setMargin(false)
        Page.getCurrent().setTitle("bunnytron")

        root.addComponent(createHeader())

        currentBody = bodies[CHOICE_CHOICE]()
        root.addComponent(currentBody)
        root.setExpandRatio(currentBody, 100)

        root.addComponent(createFooter())
    }

    private Component createHeader() {
        VerticalLayout topLayout = new VerticalLayout()
        topLayout.setStyleName(Reindeer.LAYOUT_BLACK);
        topLayout.setMargin(new MarginInfo(false, false, true, true))
        topLayout.setSizeUndefined()

        HorizontalLayout titleLayout = new HorizontalLayout();
        titleLayout.addStyleName("homeLink")
        titleLayout.setDescription("Home")
        titleLayout.setSizeUndefined()
        titleLayout.addLayoutClickListener(new LayoutEvents.LayoutClickListener() {
            @Override
            void layoutClick(LayoutEvents.LayoutClickEvent event) {
                switchBodies(CHOICE_CHOICE)
            }
        })

        topLayout.addComponent(titleLayout)

        Label label = new Label("bunnytron", ContentMode.HTML);
        label.addStyleName(Reindeer.LABEL_H1);
        titleLayout.addComponent(label);

        Embedded logo = new Embedded("", new ExternalResource("/images/bunny_icon.png"));
        logo.setHeight("33px");
        titleLayout.addComponent(logo);

        titleLayout.setComponentAlignment(label, Alignment.BOTTOM_LEFT);
        titleLayout.setComponentAlignment(logo, Alignment.BOTTOM_LEFT);

        def subtitle = new Label("warm and fluffy")
        subtitle.setStyleName(Reindeer.LABEL_SMALL)
        topLayout.addComponent(subtitle)

        return topLayout;
    }

    def switchBodies(String name) {
        def newBody = bodies[name]()
        switchIt(newBody)
    }

    def void switchIt(Component newBody) {
        root.replaceComponent(currentBody, newBody)
        root.setExpandRatio(newBody, 100)
        currentBody = newBody
    }

    private HorizontalLayout createFooter() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy");
        Label label = new Label("&copy; " + dateFormat.format(new Date()), ContentMode.HTML);
        label.setStyleName(Reindeer.LABEL_SMALL);
        HorizontalLayout layout = new HorizontalLayout(label);
        layout.setMargin(new MarginInfo(true, false, false, true));
        layout.setStyleName(Reindeer.LAYOUT_BLACK);
        layout.setSizeUndefined()
        layout.setComponentAlignment(label, Alignment.TOP_LEFT)
        return layout;
    }
}
