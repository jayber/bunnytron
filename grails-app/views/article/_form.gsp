<%@ page import="editor.Article" %>



<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'title', 'error')} required">
    <label for="title">
        <g:message code="article.title.label" default="Title"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="title" required="" value="${articleInstance?.title}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'author', 'error')} required">
    <label for="author">
        <g:message code="article.author.label" default="Author"/>
        <span class="required-indicator">*</span>
    </label>
    <g:select id="author" name="author.id" from="${editor.Person.list()}" optionKey="id" required=""
              value="${articleInstance?.author?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'body', 'error')} ">
    <label for="body">
        <g:message code="article.body.label" default="Body"/>

    </label>
    <g:textArea name="body" cols="40" rows="5" maxlength="1000000" value="${articleInstance?.body}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'service', 'error')} ">
    <label for="service">
        <g:message code="article.service.label" default="Service"/>

    </label>
    <g:select id="service" name="service.id" from="${editor.TElement.list()}" optionKey="id"
              value="${articleInstance?.service?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'createdDate', 'error')} required">
    <label for="createdDate">
        <g:message code="article.createdDate.label" default="Created Date"/>
        <span class="required-indicator">*</span>
    </label>
    <g:datePicker name="createdDate" precision="day" value="${articleInstance?.createdDate}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'maintainDate', 'error')} required">
    <label for="maintainDate">
        <g:message code="article.maintainDate.label" default="Maintain Date"/>
        <span class="required-indicator">*</span>
    </label>
    <g:datePicker name="maintainDate" precision="day" value="${articleInstance?.maintainDate}"/>
</div>

