package app

import com.vaadin.event.LayoutEvents
import com.vaadin.server.ExternalResource
import com.vaadin.ui.*
import com.vaadin.ui.themes.Reindeer

/**
 * User: James
 * Date: 15/12/12
 */
class ChoiceUI {

    public static final String CHOICE_CHOICE = "choice"
    public static final String TAXON_CHOICE = "taxonomy"
    public static final String PERSON_CHOICE = "persons"
    public static final String TRAWL_CHOICE = "trawl"
    ContainerUI container

    public createChoiceBody() {
        GridLayout hlayout = new GridLayout(2, 2)
        hlayout.setMargin(true)
        hlayout.setSpacing(true)
        hlayout.setSizeFull()

        VerticalLayout button1 = createChoiceButton(ArticleListUI.THIS_CHOICE, "/images/puppy.png", "Write and edit content")
        hlayout.addComponent(button1)
        hlayout.setComponentAlignment(button1, Alignment.MIDDLE_CENTER)

        VerticalLayout button2 = createChoiceButton(TAXON_CHOICE, "/images/frogtaxonomy2.jpg", "Taxonomy")
        hlayout.addComponent(button2)
        hlayout.setComponentAlignment(button2, Alignment.MIDDLE_CENTER)

        VerticalLayout button3 = createChoiceButton(PERSON_CHOICE, "/images/person2.jpg", "Other actions")
        hlayout.addComponent(button3)
        hlayout.setComponentAlignment(button3, Alignment.MIDDLE_CENTER)

        VerticalLayout button4 = createChoiceButton(TRAWL_CHOICE, "/images/angler-fish2.png", "Trawl the web")
        hlayout.addComponent(button4)
        hlayout.setComponentAlignment(button4, Alignment.MIDDLE_CENTER)

        return hlayout
    }

    private VerticalLayout createChoiceButton(String bodyName, String puppyPath, String labelText) {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        layout.addStyleName("imageButton")
        layout.addStyleName("homeLink")
        layout.addLayoutClickListener({ LayoutEvents.LayoutClickEvent event ->
            container.doUIAction(bodyName)
        } as LayoutEvents.LayoutClickListener)

        Label label = new Label(labelText)
        label.setStyleName(Reindeer.LABEL_H2)
        label.addStyleName("homeLink")
        layout.addComponent(label)
        layout.setComponentAlignment(label, Alignment.TOP_RIGHT)

        Image button = new Image(null, new ExternalResource(puppyPath))
        layout.addComponent(button)
        layout.setComponentAlignment(button, Alignment.TOP_CENTER)

        layout.setWidth("200px")
        return layout
    }
}
