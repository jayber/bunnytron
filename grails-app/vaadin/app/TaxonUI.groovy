package app

import com.vaadin.ui.*
import taxonomy.SubjectArea

class TaxonUI {
    ContainerUI parent
    private top

    def createBody() {


        HorizontalLayout topLayout = new HorizontalLayout()
        topLayout.setSizeFull()
        topLayout.setMargin(true)
        topLayout.setSpacing(true)

        Component tree = createTaxonomyTree()
        topLayout.addComponent(tree)
        topLayout.setExpandRatio(tree, 1)

        topLayout
    }


    def VerticalLayout createTaxonomyTree() {
        VerticalLayout layout = new VerticalLayout()
        layout.setSizeUndefined()
        layout.setSizeFull()

        Panel panel = new Panel("Taxonomy tree")
        panel.setSizeFull()
        layout.addComponent(panel)

        def tree = new Tree()
        tree.setSelectable(true)
        VerticalLayout panelLayout = new VerticalLayout()
        panel.setContent(panelLayout)
        panelLayout.addComponent(tree)

        List<SubjectArea> elements = SubjectArea.list()

        elements.each { SubjectArea it ->
            addTreeItem(it, tree)
        }

        elements.each { SubjectArea it ->
            if (!tree.hasChildren(it)) {
                tree.setChildrenAllowed(it, false)
            }
        }

        tree.expandItemsRecursively(top)

        return layout
    }

    def addTreeItem(SubjectArea it, Tree tree) {
        if (!tree.containsId(it)) {
            tree.addItem(it)
            if (it.parent != null) {
                addTreeItem(it.parent, tree)
                tree.setParent(it, it.parent)
            } else {
                top = it
            }
        }
    }

}
