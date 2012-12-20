<%@ page import="editor.Person" %>



<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'name', 'error')} required">
    <label for="name">
        <g:message code="person.name.label" default="Name"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="name" required="" value="${personInstance?.name}"/>
</div>

