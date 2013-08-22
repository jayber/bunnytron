package app

import com.vaadin.annotations.StyleSheet
import com.vaadin.annotations.Theme
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.event.LayoutEvents
import com.vaadin.server.ExternalResource
import com.vaadin.server.Page
import com.vaadin.server.VaadinRequest
import com.vaadin.shared.ui.MarginInfo
import com.vaadin.shared.ui.label.ContentMode
import com.vaadin.ui.*
import com.vaadin.ui.themes.Reindeer
import editor.Person

import java.text.SimpleDateFormat

@Theme("reindeer")
@StyleSheet([
"css/editor.css"
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
                    switchBodies(new ArticleListUI(parent: this, author: author.value).showBody())
                },
                (EditorUI.THIS_CHOICE): {
                    switchBodies(new EditorUI(parent: this).createEditorBody())
                },
                (ChoiceUI.PERSON_CHOICE): {
                    getPage().open("/index", "")
                },
                (ChoiceUI.TRAWL_CHOICE): {
                    switchBodies(new TrawlUI(parent: this).createBody())
                },
                (ChoiceUI.TAXON_CHOICE): {
                    switchBodies(new TaxonUI(parent: this).createBody())
                }
        ]

    private Component currentBody

    private ComboBox author = new ComboBox(null, new BeanItemContainer<Person>(Person.list([fetch: [service: "eager"]])))

    @Override
    protected void init(VaadinRequest request) {
        author.setNullSelectionAllowed(false)
        author.setTextInputAllowed(false)
        author.setValue(author.getItemIds()[0])
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
        topLayout.setWidth("100%")


        HorizontalLayout titleLayout = new HorizontalLayout();
        titleLayout.addStyleName("homeLink")
        titleLayout.setDescription("Home")
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

        HorizontalLayout bottomLayout = new HorizontalLayout()
        bottomLayout.setWidth("100%")
        def subtitle = new Label("warm and fluffy")
        subtitle.setStyleName(Reindeer.LABEL_SMALL)

        bottomLayout.addComponent(subtitle)
        topLayout.addComponent(bottomLayout)
        author.setNullSelectionAllowed(false)
        author.setImmediate(true)
        bottomLayout.addComponent(author)
        bottomLayout.setComponentAlignment(author, Alignment.BOTTOM_RIGHT);


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
        layout.setWidth("100%")
        layout.setComponentAlignment(label, Alignment.TOP_LEFT)
        return layout;
    }
}
