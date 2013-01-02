package app

import com.vaadin.ui.*

/**
 * User: James
 * Date: 25/12/12
 */
class SiteLayoutUI {

    ContainerUI parent

    Component createBody() {

        VerticalLayout layout = new VerticalLayout()

        TabSheet tabSheet = new TabSheet()
        tabSheet.setSizeFull()
        layout.addComponent(tabSheet)

        HorizontalLayout horizontalLayout = new HorizontalLayout()
        horizontalLayout.setMargin(true)
        horizontalLayout.setSizeFull()
        tabSheet.addTab(horizontalLayout, "Layout")

        VerticalLayout leftLayout = new VerticalLayout()
        Panel leftPanel = new Panel(leftLayout)
        leftPanel.setSizeUndefined()
        horizontalLayout.addComponent(leftPanel)

        def label = new Label("component")
        leftLayout.addComponent(label)

        def rightPanel = new Panel(new CustomLayout(new ByteArrayInputStream(
                """
<div class="slotContainer">
<div class="slot">this is the content</div>
<div class="slot">this is the content</div>
<div class="slot">this is the content3</div>
<div style="clear: both;"></div>
</div>
""".getBytes())))

        rightPanel.setSizeFull()

        horizontalLayout.addComponent(rightPanel)
        horizontalLayout.setExpandRatio(rightPanel, 100)

        return layout
    }
}
