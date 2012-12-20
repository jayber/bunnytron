package app

import com.vaadin.annotations.Theme
import com.vaadin.data.fieldgroup.FieldGroup
import com.vaadin.data.util.BeanItemContainer
import com.vaadin.server.ExternalResource
import com.vaadin.server.VaadinRequest
import com.vaadin.shared.ui.MarginInfo
import com.vaadin.shared.ui.datefield.Resolution
import com.vaadin.shared.ui.label.ContentMode
import com.vaadin.ui.*
import com.vaadin.ui.themes.Reindeer
import editor.Person

import java.text.SimpleDateFormat

@Theme("reindeer")
class PanelTest extends UI {
    Label html

    @Override
    protected void init(VaadinRequest request) {
        VerticalLayout root = new VerticalLayout()
        root.setSizeFull()
        setContent(root)

        root.addComponent(createHeader())

        def body = createBody()
        root.addComponent(body)
        root.setExpandRatio(body, 100)

        root.addComponent(createFooter())

    }

    private HorizontalLayout createHeader() {
        HorizontalLayout titleLayout = new HorizontalLayout();
        titleLayout.setMargin(new MarginInfo(false, false, true, true));
        titleLayout.setStyleName(Reindeer.LAYOUT_BLACK);

        Label label = new Label("Panel Test");
        label.setStyleName(Reindeer.LABEL_H1);
        titleLayout.addComponent(label);
        Embedded logo = new Embedded("", new ExternalResource("/images/bunny_icon.png"));
        logo.setHeight("33px");
        titleLayout.addComponent(logo);

        titleLayout.setComponentAlignment(label, Alignment.BOTTOM_LEFT);
        titleLayout.setComponentAlignment(logo, Alignment.BOTTOM_LEFT);
        return titleLayout;
    }

    private HorizontalLayout createBody() {
        HorizontalLayout topLayout = new HorizontalLayout();
        topLayout.setSizeFull()
        topLayout.setMargin(false);

        VerticalLayout leftBodyLayout = createLeftBody()
        topLayout.addComponent(leftBodyLayout);

        Panel panel = createRightBody()
        topLayout.addComponent(panel)

        return topLayout;
    }

    private Panel createRightBody() {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        Panel panel = new Panel("Content")
        panel.setContent(layout)
        panel.setSizeFull()

        html = new Label()
        html.setContentMode(ContentMode.HTML)
        layout.addComponent(html)

        return panel
    }

    private VerticalLayout createLeftBody() {
        VerticalLayout bodyLayout = new VerticalLayout();
        bodyLayout.setSizeFull()
        bodyLayout.setMargin(true);
        bodyLayout.setSpacing(true)

        bodyLayout.addComponent(createForm());

        return bodyLayout
    }

    Component createForm() {
        FieldGroup fields = new FieldGroup()
        VerticalLayout form = new VerticalLayout();
        DateField createdDate = new DateField("Created Date")
        createdDate.setResolution(Resolution.MINUTE)
        fields.bind(createdDate, "createdDate")
        form.addComponent(createdDate)

        form.addComponent(new Label("title"))

        ComboBox author = new ComboBox("Author", new BeanItemContainer<Person>(Person.list()))
        author.setNullSelectionAllowed(false)
        author.setRequired(true)
        form.addComponent(author)

        TextArea body = new TextArea("Content")
        body.setWidth("100%")
        body.setId("editorArea")
        body.setImmediate(true)
        form.addComponent(body)
        return form
    }

    private HorizontalLayout createFooter() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy");
        Label label = new Label("&copy; " + dateFormat.format(new Date()), Label.CONTENT_XHTML);
        label.setStyleName(Reindeer.LABEL_SMALL);
        HorizontalLayout layout = new HorizontalLayout(label);
        layout.setMargin(new MarginInfo(false, false, false, true));
        layout.setStyleName(Reindeer.LAYOUT_BLACK);
        return layout;
    }
}
