package app

import com.vaadin.ui.*
import trawl.Trawl

class TrawlUI {
    ContainerUI parent

    public Component createBody() {

        HorizontalLayout topLayout = new HorizontalLayout()
        topLayout.setSizeFull()
        topLayout.setMargin(true)
        topLayout.setSpacing(true)

        Table table = createTable()
        topLayout.addComponent(table)
        topLayout.setExpandRatio(table, 1)

        Component buttonPanel = createButtons()
        topLayout.addComponent(buttonPanel)
        topLayout.setExpandRatio(buttonPanel, 0)
        topLayout
    }

    Component createButtons() {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        layout.addComponent(new Button("Run now", { runTrawl() } as Button.ClickListener))
        layout
    }

    private Table createTable() {
        NamedColumnFieldContainer container = new NamedColumnFieldContainer(Trawl.list(), ["name", "trawlUrl", "lastChecked"], Trawl.class)
        final Table table = new Table("Trawls")
        table.setSizeFull()

        table.setContainerDataSource(container)
        table.selectable = true
        return table
    }

    private void runTrawl() {

    }
}
