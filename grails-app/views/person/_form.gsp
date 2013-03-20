<%@ page import="editor.Person" %>



<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'name', 'error')} required">
    <label for="name">
        <g:message code="person.name.label" default="Name"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="name" required="" value="${personInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'service', 'error')} ">
    <label for="service">
        <g:message code="person.service.label" default="Service"/>

    </label>
    <g:select id="service" name="service.id" from="${editor.TElement.list()}" optionKey="id" value="${personInstance?.service?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

