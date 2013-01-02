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
"codemirror/lib/codemirror.js",
"codemirror/mode/xml/xml.js",
"codemirror/lib/util/closetag.js",
"codemirror/lib/util/foldcode.js",
"codemirror/lib/util/simple-hint.js",
"codemirror/lib/util/formatting.js",
"codemirror/lib/util/xml-hint.js"
])
@StyleSheet([
"codemirror/lib/codemirror.css",
"css/editor.css",
"codemirror/theme/neat.css"
])
class ContainerUI extends UI {

    private VerticalLayout root

    //todo: replace this with Navigator
    def bodies =
        [
                (ChoiceUI.CHOICE_CHOICE): {
                    switchBodies(new ChoiceUI(container: this).createChoiceBody())
                },
                (ArticleListUI.THIS_CHOICE): {
                    switchBodies(new ArticleListUI(parent: this).showBody())
                },
                (EditorUI.THIS_CHOICE): {
                    switchBodies(new EditorUI(parent: this).createEditorBody())
                },
                (ChoiceUI.PERSON_CHOICE): {
                    getPage().open("/index", "")
                },
                (ChoiceUI.SITE_CHOICE): {
                    switchBodies(new SiteLayoutUI(parent: this).createBody())
                }
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

        currentBody = new Label("This is just a dummy component. Should never appear")
        bodies[ChoiceUI.CHOICE_CHOICE]()

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
                doUIAction(ChoiceUI.CHOICE_CHOICE)
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

    def doUIAction(String name) {
        bodies[name]()
    }

    def switchBodies(Component body) {
        switchIt(body)
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
