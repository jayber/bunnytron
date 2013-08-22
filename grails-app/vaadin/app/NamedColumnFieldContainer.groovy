package app

import com.vaadin.data.util.BeanItemContainer

class NamedColumnFieldContainer extends BeanItemContainer {
    private ArrayList<String> propertyIds

    protected NamedColumnFieldContainer(List items, List<String> columnFields, Class clazz) {
        super(clazz, items)
        propertyIds = columnFields
    }

    @Override
    Collection<String> getContainerPropertyIds() {
        return propertyIds
    }
}
